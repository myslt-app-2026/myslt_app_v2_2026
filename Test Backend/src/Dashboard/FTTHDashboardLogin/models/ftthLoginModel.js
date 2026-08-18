const mongoose = require('mongoose');

const ftthDashboardUserSchema = new mongoose.Schema({
  userName: { type: String, required: true, unique: true },
  privilege: { type: Number, required: true },
  password: String,
  email: String,
  isActive: { type: Boolean, default: true },
  lastLogin: Date,
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('FTTHDashboardUser', ftthDashboardUserSchema);
