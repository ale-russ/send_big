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

const User = require('./models/user_model');
const auth = require('./middleware/auth');
const userRoutes = require('./controllers/controller');

dotenv.config();

// const mongoUrl = process.env.MONGO_URI;
const mongoUrl = require('./config');

// Set up express app
const app = express();
const port = process.env.PORT || 5000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

mongoose
  .connect(mongoUrl)
  .then(() => console.log('CONNECTED TO MONGODB'))
  .catch((err) => console.log('MONGODB CONNECTION ERROR: ', err));

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

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(5).required(),
});

// Register route
// app.post('/register', async (req, res) => {
//   const { email, password } = req.body;

//   // Hash the password
//   const hashedPassword = await bcrypt.hash(password, 10);

//   try {
//     const existingUser = await User.findOne({ email: email });
//     if (existingUser) return res.status(400).json({ message: 'User already exists' });

//     // Create new user with hashed password
//     const newUser = new User({
//       email,
//       password: hashedPassword,
//     });

//     await newUser.save();

//     res.status(201).json({ message: 'User registered successfully' });
//   } catch (error) {
//     console.error(`Error in register route: ${error}`);
//     res.status(500).json({ message: 'An error occurred during registration' });
//   }
// });

// Login route
// app.post('/login', async (req, res) => {
//   try {
//     const validationResult = userSchema.validate(req.body);
//     if (validationResult.error) return res.status(400).json({ message: validationResult.error.details[0].message });

//     const { email, password } = req.body;

//     if (!email || !password) return res.status(400).json({ message: 'All fields are required' });

//     // Find the user in the database
//     const user = await User.findOne({ email });

//     // If the user does not exist, return an error response
//     if (!user) return res.status(401).json({ message: 'Invalid email or password' });

//     // Validate the password
//     const isPasswordValid = await bcrypt.compare(password, user.password);

//     if (isPasswordValid) return res.status(401).json({ message: 'Invalid email or password' });

//     // Generate a JWT token
//     const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

//     // Send user data
//     res.status(200).json({
//       message: 'User successfully logged in',
//       token,
//       user: {
//         id: user._id,
//         email: user.email,
//       },
//     });
//   } catch (error) {
//     console.error(`Error in login route: ${error.message}`);
//     res.status(500).json({ message: error.message });
//   }
// });

//Middleware to verify token
const verifyToken = (req, res, next) => {
  const token = req.header('x-auth-token');
  if (!token) return res.status(401).json({ msg: 'No token, authorization denied' });
};

//   try {
//     const decoded = jwt.verify(token, process.env.JWT_SECRET);
//     req.user = decoded.id;
//     next();
//   } catch (err) {
//     res.status(400).json({ msg: 'Token is not valid' });
//   }
// };

app.route('/login').post(userRoutes.login);
app.route('/register').post(userRoutes.register);

app.use(auth.isLoggedIn);
// Route to upload a file after user logs in
app.post('/upload', verifyToken, upload.single('file'), async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) return res.status(404).json({ msg: 'User not found' });

    const file = {
      filename: req.file.filename,
      path: req.file.path,
    };

    user.files.push(file);
    await user.save();

    res.status(200).json({ msg: 'File uploaded successfully', file });
  } catch (err) {
    res.status(500).json({ msg: 'Server error', error: err.message });
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
