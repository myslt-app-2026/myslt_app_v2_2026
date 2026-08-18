const mongoose = require("mongoose");



const RelatedPartySchema = new mongoose.Schema({
  id: { type: String, required: true },
  role: { type: String, required: true }
}, { _id: false });

const ProductOfferingSchema = new mongoose.Schema({
  id: { type: String, required: true },
  name: { type: String }
}, { _id: false });




const ProductSchema = new mongoose.Schema({

  /* --- Primary Identifier --- */

  _id: {
    type: String
  },


  /* --- TMF637 Product Inventory Fields --- */

  name: String,

  publicIdentifier: {
    type: String,
    index: true
  },

  productOffering: ProductOfferingSchema,

  relatedParty: [RelatedPartySchema],


  /* --- Broadband API Fields --- */

  customerId: String,

  category: {
    type: String,
    default: "broadband"
  },

  productOfferingId: {
    type: String,
    ref: "ProductOffering"
  },

  startDate: Date,


  /* --- Shared Status --- */

  status: {
    type: String,
    enum: [
      "created",
      "active",
      "suspended",
      "terminated",
      "Active",
      "Suspended"
    ]
  },


  /* --- TMF Metadata --- */

  "@type": {
    type: String,
    default: "Product"
  },

  "@baseType": {
    type: String,
    default: "Product"
  }

},
{
  timestamps: true,
  collection: "productInventory"
});

module.exports = mongoose.model("Product", ProductSchema);


/*const mongoose = require("mongoose");

const ProductSchema = new mongoose.Schema({
  _id: String,                // PROD_123
  customerId: String,
  category: { type: String, default: "broadband" },
  status: String,             // Active, Suspended

  productOfferingId: {
    type: String,
    ref: "ProductOffering"
  },

  startDate: Date,

  "@type": {
    type: String,
    default: "Product"
  }
}, {
  timestamps: true
});

module.exports = mongoose.model(
  "BBProduct",
  ProductSchema,
  "bbproducts"
);*/
