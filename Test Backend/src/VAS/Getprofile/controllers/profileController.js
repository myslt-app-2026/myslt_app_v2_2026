const profileService = require("../services/profileService");

const getProfile = async (req, res) => {
  try {
    const subscriberid = req.headers.subscriberid || req.query.subscriberid;

    if (!subscriberid) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberid header or query parameter is required",
      });
    }

    const response = await profileService.getProfile(subscriberid);

    return res.status(200).json(response);
  } catch (error) {
    console.error("VAS GET Profile error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  getProfile,
};