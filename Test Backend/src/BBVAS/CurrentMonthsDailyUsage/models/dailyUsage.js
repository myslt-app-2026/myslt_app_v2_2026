const mongoose = require('mongoose');

// TMF635 Usage Specification Reference Schema
const usageSpecRefSchema = new mongoose.Schema({
  id: { type: String, required: true },
  href: String,
  name: String,
});

// TMF635 Usage Characteristic Schema
const usageCharacteristicSchema = new mongoose.Schema({
  name: String,
  value: mongoose.Schema.Types.Mixed,
  unit: String,
});

// TMF635 Related Party Schema
const relatedPartySchema = new mongoose.Schema({
  id: String,
  href: String,
  name: String,
  role: String,
});

// TMF635 Usage Schema - Main Schema
const usageSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  href: String,
  description: String,
  isBilled: Boolean,
  usageDate: { type: Date, required: true },
  usageType: String,
  state: String,
  lastUpdate: { type: Date, default: Date.now },
  usageSpecification: { type: usageSpecRefSchema, required: true },
  usageCharacteristic: [usageCharacteristicSchema],
  relatedParty: [relatedPartySchema],
});

module.exports = mongoose.model('DailyUsage', usageSchema);
