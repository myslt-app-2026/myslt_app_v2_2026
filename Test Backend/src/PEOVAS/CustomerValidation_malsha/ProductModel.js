/*const mongoose = require("mongoose");

const RelatedPartySchema = new mongoose.Schema({
  id: { type: String, required: true },
  role: { type: String, required: true }
}, { _id: false });

const ProductOfferingSchema = new mongoose.Schema({
  id: { type: String, required: true },
  name: { type: String, required: true }
}, { _id: false });

const ProductSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },

  name: { type: String, required: true },

  status: {
    type: String,
    enum: ["created", "active", "suspended", "terminated"],
    required: true
  },

  publicIdentifier: {
    type: String,
    required: true,
    index: true
  },

  productOffering: {
    type: ProductOfferingSchema,
    required: true
  },

  relatedParty: {
    type: [RelatedPartySchema],
    required: true
  },

  "@type": {
    type: String,
    default: "Product"
  },

  "@baseType": {
    type: String,
    default: "Product"
  }
}, {
  collection: "productInventory"
});

module.exports = mongoose.model("Product", ProductSchema);
*/