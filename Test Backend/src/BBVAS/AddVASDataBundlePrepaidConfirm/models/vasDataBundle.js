const mongoose = require('mongoose');

const externalIdentifierSchema = new mongoose.Schema({
  '@type': { type: String, default: 'ExternalIdentifier' },
  owner: String,
  externalIdentifierType: String,
  id: String,
});

const productOrderItemSchema = new mongoose.Schema({
  id: String,
  quantity: Number,
  product: {
    id: String,
    href: String,
    name: String,
    '@type': { type: String, default: 'Product' }
  },
  productOffering: {
    id: String,
    href: String,
    name: String,
    '@type': { type: String, default: 'ProductOfferingRef' }
  }
});

const relatedPartySchema = new mongoose.Schema({
  id: String,
  href: String,
  role: String,
  name: String,
  '@type': { type: String, default: 'RelatedParty' }
});

const vasDataBundleSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // Add the unique ID field here
  href: String,
  externalId: [externalIdentifierSchema],
  priority: String,
  description: String,
  category: String,
  completionDate: Date,
  requestedCompletionDate: Date,
  requestedStartDate: Date,
  orderDate: { type: Date, default: Date.now },
  state: { type: String, default: 'acknowledged' },
  relatedParty: [relatedPartySchema],
  productOrderItem: [productOrderItemSchema]
});

const vasDataBundle = mongoose.models.vasDataBundle || mongoose.model('vasDataBundle', vasDataBundleSchema);

module.exports = vasDataBundle;