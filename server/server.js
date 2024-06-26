const express = require("express");
const multer = require("multer");
const cors = require("cors");
const path = require("path");
const bodyParser = require("body-parser");
const fs = require("fs");

// Set up express app
const app = express();
const port = process.env.PORT || 5000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

// Ensure the uploads directory exists
const uploadDir = "uploads";
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Set up storage for uploaded files
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

// Initialize multer with storage settings
const upload = multer({ storage: storage });

// Middleware to handle file uploads
app.post("/upload", upload.single("file"), (req, res) => {
  if (!req.file) {
    return res.status(400).send("No file uploaded.");
  }
  try {
    res.status(200).send("File uploaded successfully");
  } catch (err) {
    res.status(400).send("Error uploading file");
    console.error("Error uploading file: ", err);
  }
});

// Route to check server status
app.get("/", (req, res) => {
  res.send("Hello World");
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`);
});
