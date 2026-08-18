const bcrypt   = require("bcryptjs");
const User     = require("../../RegisterV2/models/user");

class CreateFTTHAdminController {
  static async createFTTHAdmin(req, res) {
    try {
      const { userName, channelID, userType } = req.body;

      if (!userName || !channelID || !userType) {
        return res.status(400).json({
          code:    "VALIDATION_ERROR",
          message: "userName, channelID and userType are required"
        });
      }

      const existingUser = await User.findOne({ username: userName });
      if (existingUser) {
        return res.status(409).json({
          code:    "USER_EXISTS",
          message: "FTTH Admin user already exists"
        });
      }

      const passwordHash = await bcrypt.hash(userName + channelID, 10);

      const newAdmin = await User.create({
        username:     userName,
        passwordHash: passwordHash,
        status:       "ACTIVE",
        individual: {
          firstName: userName,
          lastName:  "Admin",
          contactMedium: [
            {
              type:  "mobile",
              value: userName
            }
          ]
        }
      });

      return res.status(201).json({
        user_id:  newAdmin._id,
        userName: newAdmin.username,
        userType,
        channelID,
        status:   newAdmin.status,
        "@type":  "FTTHAdmin"
      });

    } catch (err) {
      return res.status(500).json({
        code:    "CREATE_FAILED",
        message: err.message || "Failed to create FTTH Admin"
      });
    }
  }
}

module.exports = CreateFTTHAdminController;