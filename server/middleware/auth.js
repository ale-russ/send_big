const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  const token = req.header("x-auth-token");
  if (!token) return res.status(401).json({ msg: "Access denied!" });

  try {
    const decodedJWT = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decodedJWT;
    next();
  } catch (err) {
    res.status(400).json({ msg: "Invalid token!" });
  }
};

module.exports = { verifyToken };
