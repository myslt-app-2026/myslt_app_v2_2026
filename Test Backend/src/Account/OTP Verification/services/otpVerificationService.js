// services/otpVerification.service.js
const User = require("../../RegisterV2/models/user");
const { generateAccessToken, generateRefreshToken } = require("../../../utilities/jwt");

exports.verifyOtpAndActivate = async ({ registrationId, otp }) => {

  const user = await User.findById(registrationId);
  if (!user) {
    throw new Error("Invalid registration ID");
  }

  if (user.status === "ACTIVE") {
    throw new Error("User already activated");
  }

  if (!user.otp || user.otp.code !== otp) {
    throw new Error("Invalid OTP");
  }

  if (user.otp.expiresAt < new Date()) {
    throw new Error("OTP expired");
  }

  // Activate identity (TMF720 lifecycle)
  user.status = "ACTIVE";
  user.otp = undefined;
  await user.save();

  // Issue tokens
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  // persist refresh token
  user.refreshToken = refreshToken;
  await user.save();

  return { accessToken, refreshToken };
};
