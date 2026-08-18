const mongoose = require('mongoose');

const ServiceRequestSchema = new mongoose.Schema({
  description: String,
  SRType: String,
  INSArea: String,
  INSSubArea: String,
  ServiceId: String,
  TTSource: String,
  note: String,
  notetype: String,
  status: {
    type: String,
    default: 'acknowledged'
  },
  requestedDate: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('ServiceRequest', ServiceRequestSchema);
