//models/ProductOfferingQualification.js
// Mongoose schema for Product Offering Qualification
const mongoose = require('mongoose');

const RelatedPartySchema = new mongoose.Schema({
  id: { type: String, required: true },
  role: { type: String, required: true }
}, { _id: false });

const ProductOfferingItemSchema = new mongoose.Schema({
  id: { type: String },
  productOffering: {
    id: { type: String, required: true },
    name: { type: String, required: true }
  },
  relatedParty: [RelatedPartySchema],
  qualificationResult: { type: String, enum: ['qualified', 'unqualified'], default: 'unqualified' }
}, { _id: false });

const ProductOfferingQualificationSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  state: { type: String, enum: ['completed', 'pending'], default: 'pending' },
  productOfferingQualificationItem: [ProductOfferingItemSchema],
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('ProductOfferingQualification', ProductOfferingQualificationSchema);
