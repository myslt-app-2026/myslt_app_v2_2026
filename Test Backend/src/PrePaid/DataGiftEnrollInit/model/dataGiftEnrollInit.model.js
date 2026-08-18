const mongoose = require("mongoose");

const DataGiftEnrollInitSchema = new mongoose.Schema({
  subscriberId: { type: String, required: true },
  packageId: { type: String, required: true },
  reciever: { type: String, required: true },
  channel: { type: String, required: true },
  url: { type: String, required: true },
  status: { type: String, enum: ["initiated", "completed", "failed"], default: "initiated" },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("DataGiftEnrollInit", DataGiftEnrollInitSchema);
