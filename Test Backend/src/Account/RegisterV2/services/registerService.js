const bcrypt = require('bcryptjs');
const User = require('../models/user');

const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

class RegisterService {
  static async register(payload) {
    const {
      username,
      password,
      firstName,
      lastName,
      email,
      mobile
    } = payload;

    // 1. Check existing user
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      throw new Error('User already exists');
    }

    // 2. Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // 3. Generate OTP
    const otpCode = generateOTP();
    const otpExpiry = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes

    // 4. Create user
    const user = await User.create({
      individual: {
        firstName,
        lastName,
        contactMedium: [
          { type: 'email', value: email },
          { type: 'mobile', value: mobile }
        ]
      },
      username,
      passwordHash,
      status: 'PENDING',
      otp: {
        code: otpCode,
        expiresAt: otpExpiry
      }
    });

    // 5. Send OTP (stub for now)
    console.log(`OTP for ${mobile}: ${otpCode}`);
    
    // otpSender.send(mobile, otpCode);
    //TODO: Integrate actual OTP sending service

    return {
      registrationId: user._id
    };
  }
}

module.exports = RegisterService;
