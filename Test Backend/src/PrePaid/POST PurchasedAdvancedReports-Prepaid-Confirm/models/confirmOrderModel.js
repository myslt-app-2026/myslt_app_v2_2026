const mongoose = require('mongoose');

const ConfirmedOrderSchema = new mongoose.Schema({
  // TMF Mandatory Attributes (TMF622)
  "@type": { type: String, default: "ProductOrder" },
  state: { 
    type: String, 
    enum: ['acknowledged', 'inProgress', 'completed', 'failed'], 
    default: 'completed' 
  },
  
  // Mapping for subscriberid header
  relatedParty: [{
    id: String,
    role: String, // e.g., 'customer'
    name: String,
    "@type": { type: String, default: "RelatedParty" }
  }],

  // Mapping for reporterPackage
  productOrderItem: [{
    id: String,
    action: { type: String, default: 'add' },
    productOffering: {
      id: String,
      name: String
    },
    // TMF637: Reference to the resulting product in inventory after confirmation
    product: {
        id: String,
        "@type": { type: String, default: "Product" }
    }
  }],

  // Non-mandatory but standard for 'Confirm' phase
  completionDate: { type: Date, default: Date.now },
  externalId: String // Can be used for payment transaction IDs
}, { timestamps: true });

module.exports = mongoose.models.ConfirmedProductOrder || mongoose.model('ConfirmedProductOrder', ConfirmedOrderSchema);