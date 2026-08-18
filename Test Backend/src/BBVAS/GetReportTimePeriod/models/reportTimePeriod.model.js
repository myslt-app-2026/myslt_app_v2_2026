const mongoose = require('mongoose');

const ReportTimePeriodSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  description: { type: String },
  startDateTime: { type: Date, required: true },
  endDateTime: { type: Date },
  status: { type: String, enum: ['active', 'completed', 'planned'], default: 'active' },
  href: { type: String },
  '@type': { type: String, default: 'ReportTimePeriod' },
  '@baseType': { type: String, default: 'Entity' }
}, { timestamps: true });

module.exports = mongoose.model('ReportTimePeriod', ReportTimePeriodSchema);
