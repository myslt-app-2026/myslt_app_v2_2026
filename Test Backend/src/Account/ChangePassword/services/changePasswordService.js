const bcrypt = require("bcryptjs");
const User = require("../../RegisterV2/models/user");

class ChangePasswordService {
  static async changePassword({ username, currentPassword, newPassword }) {
    const user = await User.findOne({ username });

    if (!user) {
      throw new Error("Invalid username or password");
    }

    if (user.status !== "ACTIVE") {
      throw new Error("User is not activated");
    }

    const isValid = await bcrypt.compare(currentPassword, user.passwordHash);
    if (!isValid) {
      throw new Error("Invalid current password");
    }

    const newHash = await bcrypt.hash(newPassword, 10);
    user.passwordHash = newHash;

    user.refreshToken = undefined;

    await user.save();

    return {
      success: true
    };
  }
}

module.exports = ChangePasswordService;


