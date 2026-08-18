const mongoose = require("mongoose");

/**
 * TMF622: RelatedParty
 */
const RelatedPartySchema = new mongoose.Schema(
  {
    id: String,
    role: String,
    name: String
  },
  { _id: false }
);

/**
 * TMF622: Channel
 */
const ChannelSchema = new mongoose.Schema(
  {
    id: String,
    name: String
  },
  { _id: false }
);

/**
 * TMF622: ProductOfferingRef
 */
const ProductOfferingRefSchema = new mongoose.Schema(
  {
    id: String,
    name: String
  },
  { _id: false }
);

/**
 * TMF622: ProductOrderItem
 */
const ProductOrderItemSchema = new mongoose.Schema(
  {
    id: String,
    action: {
      type: String,
      enum: ["add", "modify", "delete"],
      required: true
    },
    state: {
      type: String,
      enum: [
        "acknowledged",
        "inProgress",
        "completed",
        "failed"
      ],
      default: "acknowledged"
    },
    productOffering: ProductOfferingRefSchema
  },
  { _id: false }
);

/**
 * TMF622: ProductOrder
 */
const ProductOrderSchema = new mongoose.Schema(
  {
    state: {
      type: String,
      enum: [
        "acknowledged",
        "inProgress",
        "completed",
        "failed"
      ],
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

    channel: {
      type: [ChannelSchema]
    },

    externalReference: [
      {
        name: String,
        value: String
      }
    ],

    creationDate: {
      type: Date,
      default: Date.now
    }
  },
  {
    collection: "productOrder",
    timestamps: false
  }
);

module.exports = mongoose.model("ProductOrder", ProductOrderSchema);
