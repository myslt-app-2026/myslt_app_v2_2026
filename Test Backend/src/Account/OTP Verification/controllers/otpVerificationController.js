// controllers/otpVerification.controller.js
const otpService = require("../services/otpVerificationService");

exports.verifyOtp = async (req, res) => {
  try {
    const { registrationId, otp, channel } = req.body;

    if (!registrationId || !otp) {
      return res.status(400).json({
        status: "FAILED",
        error: "registrationId and otp are required"
      });
    }

    const tokens = await otpService.verifyOtpAndActivate({
      registrationId,
      otp
    });

    return res.status(200).json({
      status: "SUCCESS",
      data: tokens
    });

  } catch (error) {
    return res.status(400).json({
      status: "FAILED",
      error: error.message
    });
  }
};
