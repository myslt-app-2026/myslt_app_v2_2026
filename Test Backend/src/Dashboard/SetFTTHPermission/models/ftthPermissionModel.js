const mongoose = require('mongoose');

const ftthPermissionSchema = new mongoose.Schema({
  userName: { type: String, required: true, unique: true },
  privilege: { type: Number, required: true },
  description: String,
  isActive: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('FTTHPermission', ftthPermissionSchema);
