// src/models/usage.model.js
const mongoose = require("mongoose");

const usageCharacteristicSchema = new mongoose.Schema({
  name: { type: String, required: true },
  value: { type: mongoose.Schema.Types.Mixed, required: true },
});

const usageSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  href: { type: String },
  date: { type: Date, required: true },
  type: { type: String, enum: ["DailyDataUsage", "WeeklyDataUsage"], required: true },
  status: { type: String, default: "received" },
  usageCharacteristic: [usageCharacteristicSchema],
});

module.exports = mongoose.model("Usage", usageSchema);
