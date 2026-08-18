const mongoose = require('mongoose');

const ftthSpecificSchema = new mongoose.Schema({
  // TMF638: Service Inventory Management
  service: {
    id: { type: String, required: true },
    name: String,
    state: { type: String, default: 'active' },
    serviceType: { type: String, default: 'FTTH' },
    "@type": { type: String, default: 'Service' }
  },
  // TMF637: Product Inventory Management (Customer & Package info from MainFTTH.jsx)
  product: {
    id: { type: String, required: true },
    name: String,
    productCharacteristic: [
      { name: String, value: String } // e.g., bbPackages, billType
    ],
    relatedParty: [{
      id: String, // NIC or Passport
      name: String, // Full Name
      role: { type: String, default: 'customer' },
      characteristic: [{ name: String, value: String }] // e.g., mobile, email
    }],
    "@type": { type: String, default: 'Product' }
  },
  // TMF639: Resource Inventory Management (Hardware)
  resources: [{
    id: String,
    resourceType: String,
    serialNumber: String,
    "@type": { type: String, default: 'Resource' }
  }],
  // TMF673: Geographic Address Management
  location: {
    id: String,
    address1: String,
    city: String,
    district: String,
    latitude: String, 
    longitude: String,
    "@type": { type: String, default: 'GeographicAddress' }
  },
  serviceStatus: String
}, { timestamps: true });

module.exports = mongoose.models.FTTHSpecificData || mongoose.model('FTTHSpecificData', ftthSpecificSchema);