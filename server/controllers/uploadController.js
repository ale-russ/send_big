const express = require("express");
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const jwt = require("jsonwebtoken");
const { ObjectId } = require("mongodb");

const User = require("../models/user_model");

const { verifyToken } = require("../middleware/auth");
const { error } = require("console");

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
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

const router = express.Router();

router.post("/upload", verifyToken, upload.single("file"), async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    const file = {
      filename: req.file.filename,
      path: req.file.path,
    };

    user.files.push(file);
    await user.save();

    res.status(200).json({ msg: "File uploaded successfully", file });
  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
  }
});

router.delete("/delete-file/:filename", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ msg: "User not found" });

    const filename = req.params.filename;
    const fileIndex = user.files.findIndex(
      (file) => (file.filename = filename)
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
