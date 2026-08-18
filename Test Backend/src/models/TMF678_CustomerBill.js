const mongoose = require("mongoose");

// Money sub-schema
const MoneySchema = new mongoose.Schema({
  unit:  { type: String, default: "LKR" },
  value: { type: Number, default: 0 },
}, { _id: false });

// TimePeriod sub-schema
const TimePeriodSchema = new mongoose.Schema({
  startDateTime: { type: Date },
  endDateTime:   { type: Date },
}, { _id: false });

// BillCycleRef
const BillCycleRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  "@referredType": { type: String, default: "BillCycle" },
  "@type":         { type: String, default: "BillCycleRef" },
}, { _id: false });

// BillingAccountRef
const BillingAccountRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  ratingType:      { type: String },
  "@referredType": { type: String, default: "BillingAccount" },
  "@type":         { type: String, default: "BillingAccountRef" },
}, { _id: false });

// FinancialAccountRef
const FinancialAccountRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  "@referredType": { type: String, default: "FinancialAccount" },
  "@type":         { type: String, default: "FinancialAccountRef" },
}, { _id: false });

// PaymentMethodRef
const PaymentMethodRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  "@referredType": { type: String, default: "PaymentMethodRef" },
  "@type":         { type: String, default: "PaymentMethodRef" },
}, { _id: false });

// RelatedParty (RelatedPartyRefOrPartyRoleRef)
const RelatedPartySchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  role:            { type: String },
  "@referredType": { type: String },
  "@type":         { type: String, default: "RelatedParty" },
}, { _id: false });

// TaxItem
const TaxItemSchema = new mongoose.Schema({
  taxCategory: { type: String },
  taxRate:     { type: Number },
  taxAmount:   { type: MoneySchema },
  "@type":     { type: String, default: "TaxItem" },
}, { _id: false });

// AppliedPayment
const PaymentRefSchema = new mongoose.Schema({
  id:              { type: String },
  href:            { type: String },
  name:            { type: String },
  "@referredType": { type: String, default: "Payment" },
  "@type":         { type: String, default: "PaymentRef" },
}, { _id: false });

const AppliedPaymentSchema = new mongoose.Schema({
  appliedAmount: { type: MoneySchema },
  payment:       { type: PaymentRefSchema },
  "@type":       { type: String, default: "AppliedPayment" },
}, { _id: false });

// Attachment (billDocument)
const AttachmentSchema = new mongoose.Schema({
  id:             { type: String },
  href:           { type: String },
  attachmentType: { type: String },
  content:        { type: String },
  description:    { type: String },
  mimeType:       { type: String },
  name:           { type: String },
  url:            { type: String },
  validFor:       { type: TimePeriodSchema },
  "@type":        { type: String, default: "Attachment" },
}, { _id: false });

// Main CustomerBill Schema — TMF678 v5.0.0
const CustomerBillSchema = new mongoose.Schema({
  id:              { type: String, required: true, unique: true },
  href:            { type: String },
  billNo:          { type: String },
  description:     { type: String },
  category:        { type: String },

  // Dates
  billDate:        { type: Date },
  lastUpdate:      { type: Date, default: Date.now },
  nextBillDate:    { type: Date },
  paymentDueDate:  { type: Date },

  // Billing period
  billingPeriod:   { type: TimePeriodSchema },

  // Run type — onCycle (regular) or offCycle (on demand)
  runType: {
    type: String,
    enum: ["onCycle", "offCycle"],
    default: "offCycle",
  },

  // State — exactly as defined in TMF678 userguide
  state: {
    type: String,
    enum: [
      "new",
      "onHold",
      "validated",
      "sent",
      "settled",
      "partiallyPaid",
    ],
    default: "new",
  },

  // Money fields
  amountDue:          { type: MoneySchema },
  remainingAmount:    { type: MoneySchema },
  taxExcludedAmount:  { type: MoneySchema },
  taxIncludedAmount:  { type: MoneySchema },

  // References
  billCycle:        { type: BillCycleRefSchema },
  billingAccount:   { type: BillingAccountRefSchema },
  financialAccount: { type: FinancialAccountRefSchema },
  paymentMethod:    { type: PaymentMethodRefSchema },

  // Arrays
  relatedParty:    { type: [RelatedPartySchema],    default: [] },
  taxItem:         { type: [TaxItemSchema],         default: [] },
  appliedPayment:  { type: [AppliedPaymentSchema],  default: [] },
  billDocument:    { type: [AttachmentSchema],       default: [] },

  // TMF standard meta fields
  "@type":           { type: String, default: "CustomerBill" },
  "@baseType":       { type: String, default: "CustomerBill" },
  "@schemaLocation": { type: String },
},
{
  timestamps: true,
  versionKey: false,
});

// Define CustomerBillOnDemand schema
const CustomerBillOnDemandSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  href: { type: String },
  description: { type: String, required: true },
  name: { type: String },
  lastUpdate: { type: Date, default: Date.now },
  state: {
    type: String,
    enum: ["inProgress", "done", "rejected", "terminatedWithError"],
    default: "inProgress",
    required: true,
  },
  billingAccount: {
    id: { type: String, required: true },
    href: { type: String },
    name: { type: String },
    "@referredType": { type: String },
    "@type": { type: String },
  },
  relatedParty: {
    role: { type: String },
    "@type": { type: String },
    partyOrPartyRole: {
      id: { type: String },
      name: { type: String },
      "@referredType": { type: String },
      "@type": { type: String },
    },
  },
  characteristic: [
    {
      name: { type: String },
      value: { type: mongoose.Schema.Types.Mixed },
    },
  ],
  "@type": { type: String, default: "CustomerBillOnDemand", required: true },
});

// Export both models
module.exports = {
  TMF678_CustomerBill: mongoose.model("TMF678_CustomerBill", CustomerBillSchema),
  CustomerBillOnDemand: mongoose.model("CustomerBillOnDemand", CustomerBillOnDemandSchema),
};
