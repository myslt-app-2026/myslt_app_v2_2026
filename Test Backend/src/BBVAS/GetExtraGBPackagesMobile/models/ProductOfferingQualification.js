// models/ProductOfferingQualification.js
const mongoose = require("mongoose");

const RelatedPartySchema = new mongoose.Schema({
  id: { type: String, required: true },   // subscriberID
  role: { type: String, required: true }  // e.g. "Subscriber"
});

const ProductSpecificationSchema = new mongoose.Schema({
  name: { type: String, required: true },
  version: { type: String }
});

const CategorySchema = new mongoose.Schema({
  name: { type: String, required: true }
});

const CharacteristicSchema = new mongoose.Schema({
  name: { type: String, required: true },
  value: { type: String, required: true }
});

const PriceSchema = new mongoose.Schema({
  priceType: { type: String, required: true },  // e.g. "recurring"
  price: {
    amount: { type: Number, required: true },
    currency: { type: String, required: true }
  },
  taxIncludedAmount: {
    amount: { type: Number, required: true },
    currency: { type: String, required: true }
  }
});

const EligibleProductOfferingSchema = new mongoose.Schema({
  id: { type: String, required: true },
  name: { type: String, required: true },
  productSpecification: ProductSpecificationSchema,
  productPrice: [PriceSchema],
  characteristic: [CharacteristicSchema]
});

const CheckProductOfferingQualificationItemSchema = new mongoose.Schema({
  id: { type: String, required: true },
  action: { type: String, required: true }, // add/remove
  product: {
    productSpecification: ProductSpecificationSchema
  },
  category: CategorySchema,
  qualificationItemResult: { type: String }, // qualified/unqualified
  eligibleProductOffering: [EligibleProductOfferingSchema]
});

const ProductOfferingQualificationSchema = new mongoose.Schema({
  description: { type: String },
  state: { type: String, default: "done" },
  effectiveQualificationDate: { type: Date, default: Date.now },
  relatedParty: [RelatedPartySchema],
  checkProductOfferingQualificationItem: [CheckProductOfferingQualificationItemSchema]
});

module.exports = mongoose.model(
  "ProductOfferingQualification",
  ProductOfferingQualificationSchema
);
