// models/ExtraGbBundle.js
const mongoose = require("mongoose");

const ExtraGbBundleSchema = new mongoose.Schema({
  packageId: { type: Number, required: true },
  name: { type: String, required: true },
  volume: { type: Number, required: true },
  volumeUnit: { type: String, default: "GB" },
  price: {
    amount: { type: Number, required: true },
    currency: { type: String, default: "LKR" }
  },
  taxIncludedAmount: { type: Number, required: true },
  validPeriod: { type: Number, required: true },
  periodUnit: { type: String, default: "Days" },
  allowedBasePackages: [String],
  prePaidAllowed: { type: Boolean, default: true },
  postPaidAllowed: { type: Boolean, default: true },
  description: { type: String }
});

module.exports = mongoose.model("ExtraGbBundle", ExtraGbBundleSchema);
