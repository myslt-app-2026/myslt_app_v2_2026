//src/models/addVASDataBundlePrepaidInit.model.js
const mongoose = require("mongoose");

const VASDataBundleSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  customerId: { type: String, required: true },
  bundleName: { type: String, required: true },
  dataVolume: { type: String, required: true },  // e.g. "5GB"
  validity: { type: String, required: true },    // e.g. "30 Days"
  price: { type: Number, required: true },
  status: { type: String, enum: ["initiated", "activated", "failed"], default: "initiated" },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("VASDataBundle", VASDataBundleSchema);
