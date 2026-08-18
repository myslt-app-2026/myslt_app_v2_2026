const TokenService = require("../services/refreshTokenService");

class refreshTokenController {
  static async refreshToken(req, res) {
    try {
      const { username, refreshToken } = req.body;

      if (!username || !refreshToken) {
        return res.status(400).json({
          code: "VALIDATION_ERROR",
          message: "username and refreshToken are required"
        });
      }

      const result = await TokenService.refreshToken({
        username,
        refreshToken
      });

      return res.status(200).json(result);
    } catch (err) {
      return res.status(401).json({
        code: "TOKEN_INVALID",
        message: err.message
      });
    }
  }
}

module.exports = refreshTokenController;
