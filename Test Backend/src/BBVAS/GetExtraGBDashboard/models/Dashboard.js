const mongoose = require('mongoose');

// TMF 635 Usage Management API - UsageSummary
const UsageSummarySchema = new mongoose.Schema({
  id: { 
    type: String, 
    required: true, 
    unique: true 
  },
  href: String,
  '@type': {
    type: String,
    default: 'UsageSummary'
  },
  name: String,
  description: String,
  bucket: [{
    bucketType: String,
    remainingValue: {
      amount: Number,
      units: String
    },
    usedValue: {
      amount: Number,
      units: String
    },
    totalValue: {
      amount: Number,
      units: String
    },
    validFor: {
      startDateTime: Date,
      endDateTime: Date
    }
  }],
  status: {
    type: String,
    enum: ['active', 'inactive', 'expired'],
    default: 'active'
  },
  usageCharacteristic: [{
    name: String,
    value: mongoose.Schema.Types.Mixed
  }]
}, {
  timestamps: true,
  collection: 'usagesummaries'
});

module.exports = mongoose.model('UsageSummary', UsageSummarySchema);
