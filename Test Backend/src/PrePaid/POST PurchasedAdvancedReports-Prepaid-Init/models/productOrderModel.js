const mongoose = require('mongoose');

const ProductOrderSchema = new mongoose.Schema({
  // TMF Standard Mandatory Attributes
  '@type': { type: String, default: 'ProductOrder', required: true }, 
  state: { 
    type: String, 
    enum: ['acknowledged', 'inProgress', 'held', 'pending', 'cancelled', 'completed', 'failed'],
    default: 'acknowledged' 
  },
  
  // Mapping for 'subscriberid' header and 'activatedBy' body field
  relatedParty: [{ 
    id: String,
    name: String,
    role: String, 
    '@type': { type: String, default: 'RelatedParty' }
  }],

  // Mapping for 'reporterPackage' body field
  productOrderItem: [{ 
    id: { type: String, required: true },
    action: { type: String, default: 'add', required: true }, 
    productOffering: {
      id: { type: String, required: true },
      name: String,
      '@type': { type: String, default: 'ProductOfferingRef' }
    },
    '@type': { type: String, default: 'ProductOrderItem' }
  }],

  description: String,
  category: { type: String, default: 'Prepaid' },
  orderDate: { type: Date, default: Date.now }
}, { timestamps: true });

// CHANGED: Renamed model to 'PrepaidProductOrder' and added existence check
module.exports = mongoose.models.PrepaidProductOrder || mongoose.model('PrepaidProductOrder', ProductOrderSchema);