// services/ResendOtpService.js
const User = require('../../RegisterV2/models/user');

const generateOTP = () =>
  Math.floor(100000 + Math.random() * 900000).toString();

class ResendOtpService {
  static async resend(registrationId) {
    const user = await User.findById(registrationId);

    if (!user) {
      throw new Error('Invalid registrationId');
    }

    if (user.status !== 'PENDING') {
      throw new Error('User already verified');
    }

    // Generate new OTP
    const otpCode = generateOTP();
    const otpExpiry = new Date(Date.now() + 5 * 60 * 1000);

    user.otp = {
      code: otpCode,
      expiresAt: otpExpiry
    };

    await user.save();

    // Stub: Send OTP
    const mobile = user.individual?.contactMedium?.find(
      c => c.type === 'mobile'
    )?.value;

    const email = user.individual?.contactMedium?.find(
      c => c.type === 'email'
    )?.value;

    console.log(`Resent OTP ${otpCode} to ${mobile || email}`);

    return true;
  }
}

module.exports = ResendOtpService;
