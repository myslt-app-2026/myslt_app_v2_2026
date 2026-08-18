// controllers/AuthController.js
const ResendOtpService = require('../services/resendOTPService');

class AuthController {
  static async resendOtp(req, res) {
    try {
      const { registrationId } = req.body;

      if (!registrationId) {
        return res.status(400).json({
          status: 'FAILED',
          error: 'registrationId is required'
        });
      }

      await ResendOtpService.resend(registrationId);

      return res.json({
        status: 'SUCCESS',
        message: 'OTP has been sent',
        data: { registrationId }
      });

    } catch (err) {
      return res.status(400).json({
        status: 'FAILED',
        error: err.message
      });
    }
  }
}

module.exports = AuthController;
