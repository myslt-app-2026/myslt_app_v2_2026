const mongoose = require('mongoose');

const ftthFullDataSchema = new mongoose.Schema({
  // TMF638: Service Inventory [cite: 8]
  service: {
    id: { type: String, required: true },
    name: String,
    state: { type: String, default: 'active' },
    serviceType: { type: String, default: 'FTTH' },
    serviceCharacteristic: [
      {
        name: String, // Correct: Use the Type 'String', not a value
        value: String
      }
    ],
    "@type": { type: String, default: 'Service' }
  },

  // TMF637: Product Inventory [cite: 3]
  product: {
    id: { type: String, required: true },
    name: String, 
    productCharacteristic: [
      {
        name: String,
        value: String
      }
    ],
    relatedParty: [
      {
        id: String, // NIC / Passport
        name: String, // Full Name
        role: { type: String, default: 'owner' },
        characteristic: [
          { 
            name: String, // Corrected from "mobile" to String type
            value: String 
          }
        ],
        "@type": { type: String, default: 'RelatedParty' }
      }
    ],
    "@type": { type: String, default: 'Product' }
  },

  // TMF639: Resource Inventory
  resources: [{
    id: String,
    resourceType: String,
    serialNumber: String,
    "@type": { type: String, default: 'Resource' }
  }],

  // TMF673: Geographic Address
  location: {
    id: String,
    address1: String,
    address2: String,
    city: String,
    district: String,
    latitude: String, 
    longitude: String,
    "@type": { type: String, default: 'GeographicAddress' }
  },
  serviceStatus: String
}, { timestamps: true });

module.exports = mongoose.models.FTTHFullData || mongoose.model('FTTHFullData', ftthFullDataSchema);