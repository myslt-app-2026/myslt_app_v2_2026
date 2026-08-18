const mongoose = require('mongoose');

const ftthRequestStatusSchema = new mongoose.Schema({
  requestId: { type: String, required: true },
  status: { type: String, required: true },
  requestDate: { type: Date, required: true },
  serviceId: String,
  customerId: String,
  requestType: String,
  description: String,
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('FTTHRequestStatus', ftthRequestStatusSchema);
