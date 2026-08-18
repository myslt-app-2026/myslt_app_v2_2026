const mongoose = require("mongoose");

// ExternalIdentifier
const ExternalIdentifierSchema = new mongoose.Schema({
  id:                     { type: String },
  owner:                  { type: String },
  externalIdentifierType: { type: String },
  "@type":                { type: String, default: "ExternalIdentifier" },
}, { _id: false });

// RelatedParty
const RelatedPartySchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  role:            { type: String },
  "@referredType": { type: String },
  "@type":         { type: String, default: "RelatedParty" },
}, { _id: false });

// Channel
const ChannelSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  role:            { type: String },
  "@referredType": { type: String },
  "@type":         { type: String, default: "RelatedChannel" },
}, { _id: false });

// Note
const NoteSchema = new mongoose.Schema({
  id:     { type: String },
  author: { type: String },
  date:   { type: Date, default: Date.now },
  text:   { type: String },
  "@type":{ type: String, default: "Note" },
}, { _id: false });

// ProductCharacteristic
const ProductCharacteristicSchema = new mongoose.Schema({
  id:        { type: String },
  name:      { type: String },
  value:     { type: mongoose.Schema.Types.Mixed },
  valueType: { type: String },
  "@type":   { type: String, default: "StringCharacteristic" },
}, { _id: false });

// ProductSpecificationRef
const ProductSpecificationRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  version:         { type: String },
  "@referredType": { type: String },
  "@type":         { type: String, default: "ProductSpecificationRef" },
}, { _id: false });

// Product
const ProductSchema = new mongoose.Schema({
  id:                    { type: String },
  href:                  { type: String },
  isBundle:              { type: Boolean, default: false },
  productCharacteristic: { type: [ProductCharacteristicSchema], default: [] },
  productSpecification:  { type: ProductSpecificationRefSchema },
  "@type":               { type: String, default: "Product" },
}, { _id: false });

// ProductOfferingRef
const ProductOfferingRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  "@referredType": { type: String },
  "@type":         { type: String, default: "ProductOfferingRef" },
}, { _id: false });

// OrderPrice
const PriceSchema = new mongoose.Schema({
  taxRate:          { type: Number },
  percentage:       { type: Number },
  dutyFreeAmount:   { type: mongoose.Schema.Types.Mixed },
  taxIncludedAmount:{ type: mongoose.Schema.Types.Mixed },
  "@type":          { type: String, default: "Price" },
}, { _id: false });

const OrderPriceSchema = new mongoose.Schema({
  description:           { type: String },
  name:                  { type: String },
  priceType:             { type: String },
  recurringChargePeriod: { type: String },
  price:                 { type: PriceSchema },
  "@type":               { type: String, default: "OrderPrice" },
}, { _id: false });

// OrderTerm
const OrderTermSchema = new mongoose.Schema({
  description: { type: String },
  name:        { type: String },
  duration:    { type: mongoose.Schema.Types.Mixed },
  "@type":     { type: String, default: "OrderTerm" },
}, { _id: false });

// BillingAccountRef
const BillingAccountRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  "@referredType": { type: String },
  "@type":         { type: String, default: "BillingAccountRef" },
}, { _id: false });

// OrderItemRelationship
const OrderItemRelationshipSchema = new mongoose.Schema({
  id:               { type: String },
  relationshipType: { type: String },
  "@type":          { type: String, default: "OrderItemRelationship" },
}, { _id: false });

// ProductOrderItem
const ProductOrderItemSchema = new mongoose.Schema({
  id:                          { type: String, required: true },
  quantity:                    { type: Number, default: 1 },
  action:                      { type: String, enum: ["add", "modify", "delete", "noChange"], default: "add" },
  state:                       { type: String },
  productOffering:             { type: ProductOfferingRefSchema },
  product:                     { type: ProductSchema },
  itemPrice:                   { type: [OrderPriceSchema], default: [] },
  itemTerm:                    { type: [OrderTermSchema], default: [] },
  billingAccount:              { type: BillingAccountRefSchema },
  productOrderItemRelationship:{ type: [OrderItemRelationshipSchema], default: [] },
  "@type":                     { type: String, default: "ProductOrderItem" },
}, { _id: false });

// Main ProductOrder Schema
const ProductOrderSchema = new mongoose.Schema({
  id:                      { type: String, required: true, unique: true },
  href:                    { type: String },
  cancellationDate:        { type: Date },
  cancellationReason:      { type: String },
  category:                { type: String, default: "DataGift" },
  completionDate:          { type: Date },
  creationDate:            { type: Date, default: Date.now },
  description:             { type: String },
  expectedCompletionDate:  { type: Date },
  externalId:              { type: [ExternalIdentifierSchema], default: [] },
  notificationContact:     { type: String },
  priority:                { type: String, default: "4" },
  requestedCompletionDate: { type: Date },
  requestedStartDate:      { type: Date },
  state: {
    type: String,
    enum: [
      "acknowledged",
      "rejected",
      "pending",
      "held",
      "inProgress",
      "cancelled",
      "completed",
      "failed",
      "partial",
      "assessingCancellation",
      "pendingCancellation",
    ],
    default: "acknowledged",
  },
  channel:          { type: [ChannelSchema],          default: [] },
  note:             { type: [NoteSchema],             default: [] },
  relatedParty:     { type: [RelatedPartySchema],     default: [] },
  productOrderItem: { type: [ProductOrderItemSchema], default: [] },
  orderTotalPrice:  { type: [OrderPriceSchema],       default: [] },
  "@type":          { type: String, default: "ProductOrder" },
  "@baseType":      { type: String, default: "ProductOrder" },
  "@schemaLocation":{ type: String },
},
{
  timestamps: true,
  versionKey: false,
});

module.exports = mongoose.model("TMF622_ProductOrder", ProductOrderSchema);