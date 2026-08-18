const jwt = require("jsonwebtoken");
const User = require("../../RegisterV2/models/user");
const { generateAccessToken } = require("../../../utilities/jwt");

class refreshTokenService {
  static async refreshToken({ username, refreshToken }) {
    // verify refresh token
    let decoded;
    try {
      decoded = jwt.verify(
        refreshToken,
        process.env.JWT_REFRESH_SECRET
      );
    } catch {
      throw new Error("Invalid or expired refresh token");
    }

    const user = await User
    .findOne({ username })
    .select("+refreshToken");


    if (!user) {
      throw new Error("User not found");
    }

    if (user.refreshToken !== refreshToken) {
      throw new Error("Refresh token mismatch");
    }

    const newAccessToken = generateAccessToken(user);

    return {
      accessToken: newAccessToken
    };
  }
}

module.exports = refreshTokenService;
