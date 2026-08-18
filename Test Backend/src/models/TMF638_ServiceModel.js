// models/ServiceInventory.js
const mongoose = require('mongoose');

const ServiceInventorySchema = new mongoose.Schema(
  {
    id: String,
    state: String,
    serviceSpecification: {
      id: String,
      name: String,
      '@type': String
    },

    // Minimal safe upgrade
    relatedParty: [
      {
        id: String,
        role: String,
        '@referredType': String
      }
    ],
    
    serviceCharacteristic: [
      {
        name: String,
        value: mongoose.Schema.Types.Mixed
      }
    ],
    '@type': { type: String, default: 'Service' },
    '@baseType': { type: String, default: 'Service' }
  },
  { collection: 'serviceInventory' }
);

module.exports =  mongoose.model('ServiceInventory', ServiceInventorySchema);
