const express = require("express");
const multer = require("multer");
const fs = require("fs");
const path = require("path");

const User = require("../models/user_model");

const { verifyToken } = require("../middleware/auth");
const { route } = require("./uploadController");

// Ensure upload dir exists
const uploadDir = "uploads";
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// set up storage for uploaded files
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    cb(
      null,
      path.parse(file.originalname).name + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage: storage });

const router = express.Router();

// convert size to kb, mb, gb...
function formatFileSize(bytes) {
  if (bytes < 1024) return bytes + " B";
  else if (bytes < 1048576) return (bytes / 1024).toFixed(2) + " KB";
  else if (bytes < 1073741824) return (bytes / 1048576).toFixed(2) + " MB";
  else return (bytes / 1073741824).toFixed(2) + " GB";
}

// upload files route
router.post("/upload", verifyToken, upload.single("file"), async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    // Check if a file with the same name exists
    const fileExists = user.files.some(
      (file) => file.filename === req.file.originalname
    );
    console.log("File exists: ", fileExists);
    if (fileExists) {
      // Delete the uploaded file from the server since it should not be stored
      const filePath = path.join(uploadDir, req.file.filename);
      fs.unlink(filePath, (err) => {
        if (err) console.error("Error deleting file", err);
      });

      return res
        .status(400)
        .json({ msg: "File with the same name already exists" });
    }

    const stats = await fs.promises.stat(req.file.path);

    const file = {
      originalname: req.file.originalname,
      filename: req.file.filename,
      path: req.file.path,
      // size: req.file.size,
      size: formatFileSize(stats.size),
      createdAt: new Date(),
    };

    user.files.push(file);
    await user.save();

    res.status(200).json({ msg: "File uploaded successfully", file });
  } catch (err) {
    res.status(500).json({ msg: "Internal Server Error", error: err.message });
  }
});

// update file route
router.put("/update-file/:filename", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    const filename = req.params.filename;
    const fileIndex = user.files.find((file) => file.filename === filename);

    if (!file) return res.status(404).json({ msg: "File not found" });

    // update the filename if provided
    if (req.body.newFilename) {
      const newFilename = req.body.newFilename;
      const oldPath = path.join("uploads", file.filename);
      const newPath = path.join("uploads", newFilename);

      // Rename the file in the file system
      fs.renameSync(oldPath, newPath);

      // Update the filename in the user's file array
      file.filename = newFilename;
    }
    await user.save();

    res.status(200).json({ msg: "File information updated successfully" });
  } catch (err) {
    return res
      .status(500)
      .json({ msg: "Internal Server Error", error: err.message });
  }
});

// Get all files route
router.get("/get-files", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });
    return res.status(200).json(user.files);
  } catch (err) {
    return res.status(409).json({ msg: "No files found" });
  }
});

// Get individual file details route
router.get("/file-details/:filename", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });
    const filename = req.params.filename;
    console.log("File name: ", filename);
    const file = user.files.find(
      (file) => file.filename === filename || file.originalname === filename
    );

    console.log("File: ", file);

    if (!file) return res.status(404).json({ msg: "File not found" });

    res.status(200).json({ file });
  } catch (err) {
    return res
      .status(500)
      .json({ msg: "Internal Server Error", error: err.message });
  }
});

// Search Files route
router.get("/search", verifyToken, async (req, res) => {
  const searchQuery = req.query.q;
  if (!searchQuery)
    return res.status(400).json({ msg: "Search query is required" });

  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    // Search for files that match the query
    const matchedFiles = user.files.filter((file) =>
      file.filename.toLowerCase().includes(searchQuery.toLowerCase())
    );

    res.status(200).json({ matchedFiles });
  } catch (err) {
    return res
      .status(500)
      .json({ msg: "Internal Server Error", error: err.message });
  }
});

// filter files route
router.get("/filter-files", verifyToken, async (req, res) => {
  const { fileType, minSize, maxSize, startDate, endDate } = req.query;

  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    // Filter files based on the criteria
    const filteredFiles = user.files.filter((file) => {
      let matches = true;

      if (fileType) {
        const fileExtension = path.extname(file.filename).substring(1);
        matches = matches && fileExtension === fileType;
      }

      if (minSize) {
        const fileSize = fs.statSync(path.join("uploads", file.filename)).size;
        matches = matches && fileSize >= parseInt(minSize);
      }

      if (maxSize) {
        const fileSize = fs.statSync(path.join("uploads", file.filename)).size;
        matches = matches && fileSize <= parseInt(maxSize);
      }

      if (startDate) {
        const fileUploadDate = new Date(file.uploadDate);
        matches = matches && fileUploadDate >= new Date(startDate);
      }
      if (endDate) {
        const fileUploadDate = new Date(file.uploadDate);
        matches = matches && fileUploadDate >= new Date(endDate);
      }

      return matches;
    });

    res.status(200).json({ filteredFiles });
  } catch (err) {
    return res
      .status(500)
      .json({ msg: "Internal Server Error", error: err.message });
  }
});

// Download File route
router.get("/download-file/:filename", verifyToken, async (req, res) => {
  console.log("User: ", req.user);
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    console.log("User files: ", user);

    const filename = req.params.filename;
    const file = user.files.find((file) => file.originalname === filename);

    console.log("Found file: ", file);

    if (!file) return res.status(404).json({ msg: "File not found" });

    const filepath = path.join(uploadDir, file.filename);
    res.download(filepath, file.originalname, (err) => {
      if (err) return res.status(500).json({ msg: "Error downloading file" });
    });
  } catch (err) {
    return res
      .status(500)
      .json({ msg: "Internal Server Error", error: err.message });
  }
});

// Delete File route
router.delete("/delete-file/:filename", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    const filename = req.params.filename;
    const fileIndex = user.files.findIndex(
      (file) => file.filename === filename || file.originalname === filename
    );

    if (fileIndex === -1)
      return res.status(404).json({ msg: "File not found" });

    const filePath = path.join(uploadDir, filename);
    fs.unlink(filePath, (err) => {
      if (err)
        return res
          .status(500)
          .json({ msg: "Error deleting file", error: err.message });
    });
    user.files.splice(fileIndex, 1);
    await user.save();
  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
    console.log("Error: ", err.message);
  }
});

module.exports = router;
