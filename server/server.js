const express = require('express');
const MongoClient = require('mongodb').MongoClient;
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Joi = require('joi');
const fs = require('fs');
const path = require('path');
const cors = require('cors');
const multer = require('multer');

const mongoUrl = require('./config');
const User = require('./models/user_model');

// Set up express app
const app = express();
const port = process.env.PORT || 5000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

const client = new MongoClient(mongoUrl);

mongoose
  .connect(mongoUrl)
  .then(() => console.log('CONNECTED TO MONGODB'))
  .catch((err) => console.log('MONGODB CONNECTION ERROR: ', err));

const db = client.db('test');
const usersCollection = db.collection('users');

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(5).required(),
});

// Ensure the uploads directory exists
const uploadDir = 'uploads';
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
app.post('/upload', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }
  try {
    res.status(200).send('File uploaded successfully');
  } catch (err) {
    res.status(400).send('Error uploading file');
    console.error('Error uploading file: ', err);
  }
});

app.post('/register', async (req, res) => {
  const { name, email, password } = req.body;
  console.log('email, ', email, ' password, ', password);

  try {
    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: 'User already exists' });
    }

    // Create new user
    const newUser = new User({ name, email, password });
    await newUser.save();
    res.status(201).json(newUser);
  } catch (err) {
    res.status(500).json({ msg: 'Server error', error: err.message });
  }
});

//Login Rcoute
app.post('/login', async (req, res) => {
  try {
    const validationResult = userSchema.validate(req.body);
    if (validationResult.error) {
      res.status(400).json({ message: validationResult.error.details[0].message });
    }
    const email = req.body.email;
    const password = req.body.password;

    if (!email || !password) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    // Find the user in the database
    const user = await usersCollection.findOne({ email });

    // If the user does not exist, return an error response
    if (!user) return res.status(401).json({ message: 'Invalid email or password' });

    console.log('Password: ', password, ' userPassword, ', user.password);

    // Validate the password
    var isPasswordValid = await bcrypt.compare(password, user.password);

    console.log('isPasswordValid ', isPasswordValid);

    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Generate a JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

    // Send user data
    const userId = user._id;
    const userEmail = user.email;

    res.status(200).json({
      message: 'User successfully logged in',
    });
  } catch (error) {
    console.log(`Error: ${error}`);
    res.json({ message: error.message });
  }
});

// Route to check server status
app.get('/', (req, res) => {
  res.send('Hello World');
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`);
});
