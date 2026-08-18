const mongoose = require("mongoose");

const ProductOfferingPriceSchema = new mongoose.Schema({
  priceType: { type: String }, // recurring, oneTime
  price: {
    amount: Number,
    unit: String
  }
}, { _id: false });

const ProductSpecificationSchema = new mongoose.Schema({
  id: String,
  accessType: String,       // 4G, Fiber
  downloadSpeed: String,
  uploadSpeed: String
}, { _id: false });

const ProductOfferingSchema = new mongoose.Schema({
  _id: String,              // BB_SLT_4G_ANYTIDE
  name: String,             // Any Tide
  category: { type: String, default: "broadband" },
  offeringType: String,     // SLT 4G
  lifecycleStatus: String,  // Active, Inactive
  description: String,

  productSpecification: ProductSpecificationSchema,

  productOfferingPrice: [ProductOfferingPriceSchema],

  "@type": {
    type: String,
    default: "ProductOffering"
  }
}, {
  timestamps: true
});

module.exports = mongoose.model(
  "ProductOffering",
  ProductOfferingSchema,
  "productOfferings"
);
