const bcrypt = require("bcryptjs");
const User = require("../../RegisterV2/models/user");
const {
  generateAccessToken,
  generateRefreshToken
} = require("../../../utilities/jwt");

class loginService {
  static async login({ username, password }) {
    const user = await User.findOne({ username });

    if (!user) {
      throw new Error("Invalid username or password");
    }

    if (user.status !== "ACTIVE") {
      throw new Error("User is not activated");
    }

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      throw new Error("Invalid username or password");
    }

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    // store refresh token (recommended)
    user.refreshToken = refreshToken;
    await user.save();

    return {
      accessToken,
      refreshToken,
      user_id: user._id,
      name: `${user.individual?.firstName || ""} ${user.individual?.lastName || ""}`.trim()
    };
  }
}

module.exports = loginService;
