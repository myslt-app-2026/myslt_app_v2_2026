/**
 * TMF633 - Service Reservation (OSS Loop Reservation)
 * Collection: ossLoopReservations
 */
const mongoose = require('mongoose');

const RelatedPartySchema = new mongoose.Schema({
  id: String,
  name: String,
  role: String
}, { _id: false });

const ServiceReservationSchema = new mongoose.Schema({
  _id: { type: String, default: () => new mongoose.Types.ObjectId().toString() },
  description: String,
  relatedParty: [RelatedPartySchema],
  requestedStartDate: Date,
  requestedEndDate: Date,
  reservationState: String,
  attributes: mongoose.Schema.Types.Mixed,
  "@type": { type: String, default: 'ServiceReservation' }
}, { collection: 'ossLoopReservations', timestamps: true });

module.exports = mongoose.models.TMF633_ServiceReservation || mongoose.model('TMF633_ServiceReservation', ServiceReservationSchema);
