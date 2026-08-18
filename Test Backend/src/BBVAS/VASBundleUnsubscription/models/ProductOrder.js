const mongoose = require("mongoose");

/* ---------- Shared Subschemas ---------- */

const RelatedPartySchema = new mongoose.Schema({
  id: String,
  role: String,
  name: String,
  "@referredType": String
}, { _id: false });

const ChannelSchema = new mongoose.Schema({
  id: String,
  name: String
}, { _id: false });

const ProductOfferingRefSchema = new mongoose.Schema({
  id: String,
  name: String
}, { _id: false });

const ProductOrderItemSchema = new mongoose.Schema({
  id: String,
  action: {
    type: String,
    enum: ["add", "modify", "delete"],
    required: true
  },
  state: {
    type: String,
    enum: ["acknowledged", "inProgress", "completed", "failed"],
    default: "acknowledged"
  },
  productOffering: ProductOfferingRefSchema
}, { _id: false });

/* ---------- TMF622 ProductOrder ---------- */

const ProductOrderSchema = new mongoose.Schema({
  /* TMF core */
  externalId: String,
  description: String,
  category: String,
  priority: String,

  state: {
    type: String,
    enum: ["acknowledged", "inProgress", "completed", "failed"],
    default: "acknowledged"
  },

  orderItem: {
    type: [ProductOrderItemSchema],
    required: true
  },

  relatedParty: {
    type: [RelatedPartySchema],
    required: true
  },

  channel: [ChannelSchema],

  externalReference: [{
    name: String,
    value: String
  }],

  requestedStartDate: Date,
  requestedCompletionDate: Date,
  creationDate: { type: Date, default: Date.now },
  completionDate: Date

}, {
  collection: "productOrder",
  timestamps: false
});

module.exports =
  mongoose.models.ProductOrder ||
  mongoose.model("ProductOrder", ProductOrderSchema);
