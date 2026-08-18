const changeBBPasswordService = require("../services/changeBBPasswordService");

const changeBBPassword = async (req, res) => {
  try {
    const { subscriberId, broadbandUsername, username, newPassword } = req.body;

    const selectedUsername = broadbandUsername || username;

    if (!subscriberId) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberId is required",
      });
    }

    if (!selectedUsername) {
      return res.status(400).json({
        error: "Bad Request",
        message: "broadbandUsername is required",
      });
    }

    if (!newPassword) {
      return res.status(400).json({
        error: "Bad Request",
        message: "newPassword is required",
      });
    }

    if (newPassword.length < 8) {
      return res.status(400).json({
        error: "Bad Request",
        message: "newPassword must be at least 8 characters",
      });
    }

    const response = await changeBBPasswordService.changeBBPassword(req.body);

    return res.status(200).json(response);
  } catch (error) {
    console.error("Change BB Password error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  changeBBPassword,
};