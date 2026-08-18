/**
 * ProductOffering model for TMF620 Product Catalog Management API
 * Maps to MongoDB collection: productOfferings
 */
const mongoose = require('mongoose');

const ProductOfferingSchema = new mongoose.Schema(
  {
    _id: String,
    name: String,
    description: String,
    lifecycleStatus: String,
    offeringType: String,
    productSpecification: {
      type: mongoose.Schema.Types.Mixed,
      default: {}
    },
    productOfferingPrice: Array,
    category: Array
  },
  { collection: 'productOfferings', strict: false }
);

module.exports =
  mongoose.models.ProductOfferingTMF620 ||
  mongoose.model('ProductOfferingTMF620', ProductOfferingSchema);
