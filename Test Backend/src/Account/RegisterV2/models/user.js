const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema(
  {
    // ---- TMF632: Individual ----
    individual: {
      firstName: { type: String, required: true },
      lastName: { type: String, required: true },
      contactMedium: [
        {
          type: {
            type: String, // email | mobile
            required: true
          },
          value: {
            type: String,
            required: true
          }
        }
      ]
    },

    // ---- TMF672: UserAccount ----
    username: {
      type: String,
      required: true,
      unique: true
    },

    passwordHash: {
      type: String,
      required: true
    },

    status: {
      type: String,
      enum: ['PENDING', 'ACTIVE', 'SUSPENDED'],
      default: 'PENDING'
    },

    // OTP-related (platform-level, not TMF)
    otp: {
      code: String,
      expiresAt: Date
    },

    // Refresh token storage (platform-level)
    refreshToken: {
      type: String,
      select: false
    }
  },
  {
    timestamps: true
  }
);

module.exports = mongoose.model('User', UserSchema);
