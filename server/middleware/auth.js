const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

const indexFile = require('../server');

dotenv.config();
const jwtSecret = process.env.JWT_SECRET;

exports.authenticationToken = async (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.status(401).json({ message: 'Access denied. No token provided.' });

  jwt.verify(token, jwtSecret, (err, user) => {
    if (err) return res.status(403).json({ message: 'Access denied. Invalid token.' });

    req.user = user;
    next();
  });
};

exports.generateToken = async (req, res, next) => {
  const payload = {
    id: user.id,
    username: user.username,
  };

  const token = jwt.sign(payload, jwtSecret);
  return token;
};

exports.isLoggedIn = (req, res, next) => {
  if (!indexFile.globalToken) {
    res.redirect('/login');
    return;
  }

  //The user is logged in, so continue to the next middleware function
  next();
};
