// userController.js
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Joi = require("joi");
const { ObjectId } = require("mongodb");
const User = require("../models/user_model");

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(5).required(),
});

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

// Function to handle user registration
async function register(req, res, usersCollection) {
  const validationResult = userSchema.validate(req.body);

  if (validationResult.error)
    return res
      .status(400)
      .json({ message: validationResult.error.details[0].message });

  if (!req.body.email || !req.body.password)
    return res.status(400).json({ message: "All fields are required" });

  const emailExists = await checkEmailStatus(usersCollection, req.body.email);
  if (emailExists)
    return res.status(409).json({ message: "Email already exists" });

  // Hash the password
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(req.body.password, salt);

  const newUser = {
    email: req.body.email,
    password: hashedPassword,
  };

  try {
    await usersCollection.insertOne(newUser);
    delete newUser.password;
    res.status(201).json({ message: "User created successfully", newUser });
  } catch (err) {
    return res.status(500).json({ msg: "Server error", error: err.message });
  }
}

// Function to handle user login
async function login(req, res, usersCollection) {
  try {
    const validationResult = userSchema.validate(req.body);
    if (validationResult.error)
      return res
        .status(400)
        .json({ message: validationResult.error.details[0].message });

    const email = req.body.email;
    const password = req.body.password;

    if (!email || !password)
      return res.status(400).json({ message: "All fields are required" });

    // Find the user in the database
    const user = await usersCollection.findOne({ email });

    // If the user does not exist, return an error response
    if (!user)
      return res.status(401).json({ message: "Invalid email or password" });

    // Validate the password
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    // Generate a JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);

    // Send user data
    const userId = user._id;
    const userEmail = user.email;

    res.status(200).json({
      message: "User successfully logged in",
      token,
      userId,
      userEmail,
    });
  } catch (error) {
    console.log(`Error: ${error}`);
    res.json({ message: error.message });
  }
}

module.exports = {
  checkEmailStatus,
  fetchUserData,
  register,
  login,
};
