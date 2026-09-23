const ChangePasswordService = require("../services/changePasswordService");

class changePasswordController {
  static async changePassword(req, res) {
    try {
      const username = req.body.username;
      const currentPassword = req.body.currentPassword || req.body.oldPassword;
      const newPassword = req.body.newPassword;

      if (!username || !currentPassword || !newPassword) {
        return res.status(400).json({
          code: "VALIDATION_ERROR",
          status: "FAILED",
          success: false,
          message:
            "username, oldPassword (or currentPassword) and newPassword are required"
        });
      }

      await ChangePasswordService.changePassword({
        username,
        currentPassword,
        newPassword
      });

      return res.status(200).json({
        code: "PASSWORD_CHANGED",
        status: "SUCCESS",
        success: true,
        message: "Password changed successfully"
      });
    } catch (err) {
      return res.status(401).json({
        code: "CHANGE_PASSWORD_FAILED",
        status: "FAILED",
        success: false,
        message: err.message || "Unable to change password"
      });
    }
  }
}

module.exports = changePasswordController;

