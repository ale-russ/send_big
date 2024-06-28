const bcrypt = require('bcrypt');
const { ObjectId } = require('mongodb');
const dotenv = require('dotenv');
const MongoClient = require('mongodb').MongoClient;
const jwt = require('jsonwebtoken');
const Joi = require('joi');

const User = require('../models/user_model');

dotenv.config();

const mongo_url = process.env.MONGODB_URL;
const client = new MongoClient(mongo_url);
const db = client.db('test');
const userCollection = db.collection('users');

const registerSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

async function checkEmailStatus(email) {
  const user = await userCollection.findOne({ email });
  return user !== null;
}

async function fetchUserData(id) {
  const objectId = ObjectId.createFromHexString(id);
  const user = userCollection.findOne({ _id: objectId });
  return user;
}

exports.register = async (req, res, next) => {
  const validationResult = registerSchema.validate(req.body);
  if (validationResult.error) return res.status(400).json({ message: validationResult.error.details[0].message });

  const newUser = {
    email: req.body.email,
    password: req.body.password,
  };

  if (!newUser.email || !newUser.password) return res.status(400).json({ message: 'All fields are required' });

  const emailExists = await checkEmailStatus(newUser.email);

  if (emailExists) return res.status(409).json({ message: 'Email already exists' });

  try {
    await userCollection.insertOne(newUser);
    const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET);
    delete user.password;
    user.token = token;
    return res.status(201).json({
      message: 'User created successfully',
      user: user,
    });
  } catch (err) {
    console.log(`Error in catch: ${err}`);
    return res.status(500).json({ message: err.message });
    // next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) return res.status(400).json({ message: 'All fields are required' });

    const user = await User.findOne({ email });

    if (!user) return res.json({ msg: 'Invalid Credentials', status: false });

    const hashedPassword = await bcrypt.hash(password, 10);

    const isPasswordValid = await bcrypt.compare(password, hashedPassword);

    if (!isPasswordValid) return res.json({ msg: 'Invalid Credentials', status: false });

    req.user = user;
    const currentUser = Object.assign(user);
    delete currentUser.password;

    currentUser.token = jwt.sign({ id: currentUser.id }, process.env.JWT_SECRET);

    indexFile.globalToken = currentUser.token;

    res.set('authorization', `Bearer ${currentUser.token}`);

    res.status(200).json({
      message: 'User successfully logged in',
      user: currentUser,
    });
  } catch (error) {
    return res.status(500).json({ message: 'Internal Server Error' });
  }
};

module.exports.setAvatar = async (req, res, next) => {
  try {
    const userId = req.params.id;

    const avatarImage = req.body.image;

    const userData = await User.findByIdAndUpdate(
      userId,
      {
        isAVatarImageSet: true,
        avatarImage,
      },
      { new: true }
    ).select('-password');

    return res.json({
      isSet: userData.isAVatarImageSet,
      image: userData.avatarImage,
    });
  } catch (error) {
    next(error);
  }
};

module.exports.getAllUsers = async (req, res, next) => {
  try {
    const users = await User.find({ _id: { $ne: req.params.id } }).select(['email', 'username', 'avatarImage', '_id']);
    return res.json(users);
  } catch (error) {
    next(error);
  }
};
