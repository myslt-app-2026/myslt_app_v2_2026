const User = require("../../RegisterV2/models/user");
const { generateAccessToken, generateRefreshToken } = require("../../../utilities/jwt");

class AuthenticationFTTHAdminController {
  static async authenticationFTTHAdmin(req, res) {
    try {
      const { userName, channelID, userType } = req.body;

      if (!userName || !channelID || !userType) {
        return res.status(400).json({
          code:    "VALIDATION_ERROR",
          message: "userName, channelID and userType are required"
        });
      }

      const user = await User.findOne({ username: userName });

      if (!user) {
        return res.status(404).json({
          code:    "USER_NOT_FOUND",
          message: "Admin user not found"
        });
      }

      if (user.status !== "ACTIVE") {
        return res.status(401).json({
          code:    "AUTH_FAILED",
          message: "Admin user is not activated"
        });
      }

      if (userType !== "ADMIN") {
        return res.status(403).json({
          code:    "AUTH_FAILED",
          message: "User is not authorized as FTTH Admin"
        });
      }

      const accessToken  = generateAccessToken(user);
      const refreshToken = generateRefreshToken(user);

      user.refreshToken = refreshToken;
      await user.save();

      return res.status(200).json({
        accessToken,
        refreshToken,
        user_id:  user._id,
        userName: user.username,
        userType,
        channelID,
        name:     `${user.individual?.firstName || ""} ${user.individual?.lastName || ""}`.trim(),
        "@type":  "FTTHAdminAuthentication"
      });

    } catch (err) {
      return res.status(500).json({
        code:    "AUTH_FAILED",
        message: err.message || "Authentication failed"
      });
    }
  }
}

module.exports = AuthenticationFTTHAdminController;