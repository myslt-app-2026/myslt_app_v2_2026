const ChangePasswordService = require("../services/changePasswordService");

class changePasswordController {
  static async changePassword(req, res) {
    try {
      const { username, currentPassword, newPassword } = req.body;

      if (!username || !currentPassword || !newPassword) {
        return res.status(400).json({
          code: "VALIDATION_ERROR",
          message:
            "username, currentPassword and newPassword are required"
        });
      }

      await ChangePasswordService.changePassword({
        username,
        currentPassword,
        newPassword
      });

      return res.status(200).json({
        code: "PASSWORD_CHANGED",
        message: "Password changed successfully"
      });
    } catch (err) {
      return res.status(401).json({
        code: "CHANGE_PASSWORD_FAILED",
        message: err.message || "Unable to change password"
      });
    }
  }
}

module.exports = changePasswordController;

