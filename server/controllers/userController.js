// userController.js
const bcrypt = require("bcryptjs");
const express = require("express");
const jwt = require("jsonwebtoken");
const Joi = require("joi");
const { ObjectId } = require("mongodb");
const MongoClient = require("mongodb").MongoClient;
const dotenv = require("dotenv");

const User = require("../models/user_model");
const { verifyToken } = require("../middleware/auth");

dotenv.config();

const mongoUrl = process.env.MONGODB_URL;

const router = express.Router();

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(5).required(),
});

const client = new MongoClient(mongoUrl);

const db = client.db("test");
const usersCollection = db.collection("users");

// Function to check if an email exists in the database
async function checkEmailStatus(usersCollection, email) {
  const user = await usersCollection.findOne({ email });
  return user !== null;
}

// Function to fetch user data by ID
async function fetchUserData(usersCollection, id) {
  const objectId = ObjectId.createFromHexString(id);
  const user = usersCollection.findOne({ _id: objectId });
  return user;
}

router.post("/register", async (req, res) => {
  const validationResult = userSchema.validate(req.body);

  // check for validation
  if (validationResult.error)
    return res
      .status(400)
      .json({ msg: validationResult.error.details[0].message });

  const { email, password } = req.body;

  if (!email || !password)
    return res.status(400).json({ msg: "All fields are required" });

  // Check if email exists
  const isEmailTaken = await checkEmailStatus(usersCollection, email);
  if (isEmailTaken)
    return res.status(409).json({ msg: "Email already exists" });

  // hash the password
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);

  // Create new user object and insert into the database
  const newUser = { email, password: hashedPassword };

  try {
    await usersCollection.insertOne(newUser);
    delete newUser.password;
    res.status(201).json({ message: "User created successfully", newUser });
  } catch (err) {
    return res.status(500).json({ msg: "Server error", error: err.message });
  }
});

// login route
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password)
    return res.status(400).json({ msg: "All fields are required" });
  const user = await usersCollection.findOne({ email });
  if (!user) return res.status(401).json({ msg: "Invalid email or password" });
  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid)
    return res.status(401).json({ msg: "Invalid email or password" });
  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
  const userId = user._id;
  const userEmail = user.email;
  res.status(200).json({
    message: "User successfully logged in",
    token,
    userId,
    userEmail,
  });
});

// route to get user information
router.get("/user-info", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    if (!user) return res.status(404).json({ msg: "User not found" });
    delete user.password;
    res.status(200).json({ user });
  } catch (err) {}
});

module.exports = router;
