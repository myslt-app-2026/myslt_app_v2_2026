const mongoose = require('mongoose');

const usageCharacteristicSchema = new mongoose.Schema({
  name: String,
  valueType: String,
  value: mongoose.Schema.Types.Mixed
});

const relatedPartySchema = new mongoose.Schema({
  id: String,
  name: String,
  role: String,
  '@referredType': String
});

const enhancedCurrentDailyUsageSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  href: String,
  usageDate: { type: Date, default: Date.now },
  description: String,
  usageType: String,
  status: { type: String, default: "received" },
  subscriberID: String,
  billDate: String,
  usageCharacteristic: [usageCharacteristicSchema],
  relatedParty: [relatedPartySchema],
  usageSpecification: {
    id: String,
    name: String,
    '@referredType': String
  }
});

module.exports = mongoose.model(
  'EnhancedCurrentDailyUsage',
  enhancedCurrentDailyUsageSchema
);
