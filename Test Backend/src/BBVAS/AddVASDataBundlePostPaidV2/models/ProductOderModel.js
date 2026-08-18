// const mongoose = require('mongoose');

// const RelatedPartySchema = new mongoose.Schema({
//   id: String,
//   role: String,
//   name: String,
//   '@referredType': String
// }, { _id: false });

// const ChannelSchema = new mongoose.Schema({
//   id: String,
//   name: String
// }, { _id: false });

// const ProductOfferingSchema = new mongoose.Schema({
//   id: String,
//   name: String
// }, { _id: false });

// const ProductSchema = new mongoose.Schema({
//   id: String,
//   name: String
// }, { _id: false });

// const ProductOrderItemSchema = new mongoose.Schema({
//   id: String,
//   action: { type: String, enum: ['add', 'modify', 'delete'] },
//   productOffering: ProductOfferingSchema,
//   product: ProductSchema
// }, { _id: false });

// const ProductOrderSchema = new mongoose.Schema({
//   externalId: String,
//   description: String,
//   category: String,
//   priority: String,
//   requestedStartDate: Date,
//   requestedCompletionDate: Date,
//   state: { type: String, default: 'acknowledged' },
//   channel: ChannelSchema,
//   relatedParty: [RelatedPartySchema],
//   productOrderItem: [ProductOrderItemSchema],
//   creationDate: { type: Date, default: Date.now },
//   completionDate: Date
// }, { timestamps: true });

// // module.exports = mongoose.model('ProductOrder', ProductOrderSchema);
// module.exports = mongoose.model("ProductOrder", ProductOrderSchema);

