// utils/jwt.js
const jwt = require("jsonwebtoken");

const ACCESS_SECRET = process.env.JWT_ACCESS_SECRET;
const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET;

exports.generateAccessToken = (user) =>
  jwt.sign(
    { sub: user._id, username: user.username },
    ACCESS_SECRET,
    { expiresIn: "15m" }
  );

exports.generateRefreshToken = (user) =>
  jwt.sign(
    { sub: user._id },
    REFRESH_SECRET,
    { expiresIn: "7d" }
  );
