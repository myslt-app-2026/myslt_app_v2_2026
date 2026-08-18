// models/Service.js
const mongoose = require('mongoose');

// --- Sub-schemas (no _id to avoid extra ObjectIds) ---
const ServiceSpecificationSchema = new mongoose.Schema(
  {
    id: String,
    name: String,
    type: String
  },
  { _id: false }
);

const RelatedPartySchema = new mongoose.Schema(
  {
    id: String,
    name: String,
    role: String,
    '@referredType': String
  },
  { _id: false }
);

const ServiceCharacteristicSchema = new mongoose.Schema(
  {
    id: String,
    name: String,
    valueType: String,
    value: mongoose.Schema.Types.Mixed
  },
  { _id: false }
);

// --- Main Service schema ---
const ServiceSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true },
    name: String,
    category: String,
    description: String,
    state: {
      type: String,
      enum: [
        'feasabilityChecked',
        'designed',
        'reserved',
        'inactive',
        'active',
        'terminated'
      ],
      default: 'active'
    },
    serviceSpecification: ServiceSpecificationSchema,
    relatedParty: [RelatedPartySchema],
    serviceCharacteristic: [ServiceCharacteristicSchema],
    startDate: Date,
    endDate: Date
  },
  { timestamps: true }
);

// Export the model (guarded so it’s defined only once)
module.exports =
  mongoose.models.Service || mongoose.model('Service', ServiceSchema);
