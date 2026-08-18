const AuthService = require("../services/loginService");

class loginController {
  static async login(req, res) {
    try {
      const { username, password, channelID } = req.body;

      if (!username || !password) {
        return res.status(400).json({
          code: "VALIDATION_ERROR",
          message: "username and password are required"
        });
      }

      const result = await AuthService.login({
        username,
        password,
        channelID
      });

      return res.status(200).json(result);
    } catch (err) {
      return res.status(401).json({
        code: "AUTH_FAILED",
        message: err.message || "Invalid credentials"
      });
    }
  }
}

module.exports = loginController;
