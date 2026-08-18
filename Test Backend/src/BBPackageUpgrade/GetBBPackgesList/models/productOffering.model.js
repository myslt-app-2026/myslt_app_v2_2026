const mongoose = require('mongoose');

function normalize(value) {
  if (!value) return value;
  return value
    .replace(/\u00A0/g, ' ')   // remove non-breaking spaces
    .replace(/\s+/g, '')      // remove ALL whitespace
    .toUpperCase();           // normalize case
}

const ProductOfferingSchema = new mongoose.Schema(
  {
    bbType: {
      type: String,
      required: true,
      index: true,
      set: normalize
    },
    currentProductName: {
      type: String,
      required: true,
      index: true,
      set: normalize
    },
    category: {
      type: String,
      enum: ['upgrade', 'downgrade'],
      required: true
    },
    productOffering: {
      name: {
        type: String,
        required: true
      },
      productOfferingCode: {
        type: String,
        required: true
      }
    }
  },
  {
    timestamps: true
  }
);

module.exports =
  mongoose.models.ProductOfferingQualification ||
  mongoose.model('ProductOfferingQualification', ProductOfferingSchema);
