// controllers/ftthOrder.controller.js

const crypto = require("crypto");
const ProductOrder = require("../../../models/TMF622_ProductOrder");

exports.generateFTTHSecretCode = async (req, res) => {
  try {
    const { servicetype } = req.body;

    if (!servicetype) {
      return res.status(400).json({
        error: "servicetype is required"
      });
    }

    // Generate 6-digit secret code
    const secretCode = crypto.randomInt(100000, 999999).toString();

    return res.status(200).json({
      servicetype,
      secretCode,
      expiresIn: "5m"
    });

  } catch (err) {
    return res.status(500).json({
      error: err.message
    });
  }
};