const mongoose = require("mongoose");

const UnsubscribeAdvancedReportsSchema = new mongoose.Schema(
  {
    activatedBy: { type: String, required: true }
  },
  { timestamps: true }
);

module.exports = mongoose.model(
  "UnsubscribeAdvancedReports",
  UnsubscribeAdvancedReportsSchema
);
