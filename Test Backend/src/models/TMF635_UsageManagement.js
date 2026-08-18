const mongoose = require("mongoose");

const UsageManagementSchema = new mongoose.Schema(
{
  subscriberID: {
    type: String,
    required: true
  },

  receiver: {
    type: String
  },

  transferType: {
    type: String
  },

  maxAmount: {
    type: Number
  },

  remainingAmount: {
    type: Number
  },

  volume: {
    type: Number
  },

  category: {
    type: String
  },

  channel: {
    type: String
  },

  unit: {
    type: String,
    default: "MB"
  },

  status: {
    type: String,
    default: "active"
  }

},
{ timestamps: true }
);

module.exports = mongoose.model("TMF635_UsageManagement", UsageManagementSchema);