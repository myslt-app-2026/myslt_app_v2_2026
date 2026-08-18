// const mongoose = require('mongoose');

// const ProspectContactSchema = new mongoose.Schema({
//   preferred: Boolean,
//   mediumType: String,
//   characteristic: {
//     emailAddress: String,
//     phoneNumber: String,
//     street1: String,
//     postCode: String,
//     city: String,
//     country: String
//   },
//   validFor: {
//     startDateTime: Date,
//     endDateTime: Date
//   }
// });

// const RelatedPartySchema = new mongoose.Schema({
//   id: String,
//   href: String,
//   name: String,
//   role: String,
//   '@referredType': String
// });

// const SalesLeadSchema = new mongoose.Schema({
//   id: { type: String, required: true, unique: true },
//   href: { type: String, required: true },
//   '@type': { type: String, default: 'SalesLead' },
//   name: { type: String, required: true },
//   description: String,
//   referredDate: Date,
//   type: String,
//   rating: String,
//   priority: String,
//   estimatedRevenue: {
//     unit: String,
//     value: Number
//   },
//   validFor: {
//     startDateTime: Date,
//     endDateTime: Date
//   },
//   marketSegment: {
//     id: String,
//     href: String,
//     name: String
//   },
//   marketingCampaign: {
//     id: String,
//     href: String,
//     name: String
//   },
//   channel: {
//     id: String,
//     name: String,
//     role: String
//   },
//   productOffering: {
//     id: String,
//     href: String,
//     name: String
//   },
//   product: {
//     id: String,
//     href: String
//   },
//   category: {
//     id: String,
//     href: String,
//     name: String
//   },
//   salesOpportunity: {
//     id: String,
//     href: String,
//     name: String
//   },
//   note: [{
//     author: String,
//     date: Date,
//     text: String
//   }],
//   relatedParty: [RelatedPartySchema],
//   prospectContact: [ProspectContactSchema],
//   status: { type: String, default: 'acknowledged' },
//   statusChangeDate: { type: Date, default: Date.now },
//   statusChangeReason: { type: String, default: 'Lead created' },
//   creationDate: { type: Date, default: Date.now }
// });

// module.exports = mongoose.model('SalesLead', SalesLeadSchema);
