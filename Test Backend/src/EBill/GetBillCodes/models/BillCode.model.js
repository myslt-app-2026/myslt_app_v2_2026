const mongoose = require('mongoose');

// Define a schema for a TMF BillDeliveryMethod resource (a conceptual resource derived from the Bill Handling Codes)
const BillCodeSchema = new mongoose.Schema({
    // TMF 'id' attribute, derived from the legacy BILL_HANDLING_CODE
    id: { type: String, required: true, unique: true }, 
    
    // TMF 'name' attribute, derived from the legacy BILL_HANDLING_CODE_NAME
    name: { type: String, required: true }, 
    
    // TMF 'description' attribute, derived from the legacy BILL_HANDLING_CODE_DESC
    description: { type: String }, 
    
    // TMF Meta-attributes
    href: { type: String },
    '@type': { type: String, default: 'BillDeliveryMethod' }, 
    '@baseType': { type: String, default: 'BaseEntity' },
    
    // Custom classification for filtering
    deliveryChannel: { type: String, enum: ['HardCopy', 'Email', 'App', 'SMS', 'Corporate', 'Other'], default: 'Other' }, 

}, {
    timestamps: true,
    collection: 'BillDeliveryMethods' // TMF-friendly collection name
});

const BillCode = mongoose.model('BillDeliveryMethod', BillCodeSchema);

module.exports = BillCode;