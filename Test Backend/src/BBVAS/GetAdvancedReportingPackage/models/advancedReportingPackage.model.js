const mongoose = require('mongoose');

const AdvancedReportingPackageSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  description: { type: String },
  reportType: { type: String, enum: ['financial', 'operational', 'customer', 'custom'], default: 'custom' },
  generatedDate: { type: Date, default: Date.now },
  status: { type: String, enum: ['available', 'processing', 'failed'], default: 'available' },
  downloadLink: { type: String },
  '@type': { type: String, default: 'AdvancedReportingPackage' },
  '@baseType': { type: String, default: 'Entity' }
}, { timestamps: true });

module.exports = mongoose.model('AdvancedReportingPackage', AdvancedReportingPackageSchema);
