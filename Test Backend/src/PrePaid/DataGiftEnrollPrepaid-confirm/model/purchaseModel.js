const mongoose = require("mongoose");

const PurchaseSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  href: { type: String },
  
  relatedParty: {
    id: { type: String, required: true },           
    role: { type: String, default: "Customer" },
    name: { type: String },
    "@referredType": { type: String, default: "Individual" }
  },


  purchaseID: { type: String, required: true },
  payId: { type: String, required: true },
  pgResponseCode: { type: String, required: true },
  data: { type: mongoose.Schema.Types.Mixed },
  state: { 
    type: String, 
    enum: ["acknowledged", "inProgress", "completed", "failed", "cancelled"],
    default: "acknowledged" 
  },
  
  orderDate: { type: Date, default: Date.now },
  completionDate: { type: Date },
  channel: {
    id: { type: String },
    name: { type: String },
    "@type": { type: String, default: "Channel" }
  },
  note: [
    {
      date: { type: Date, default: Date.now },
      author: { type: String },
      text: { type: String }
    }
  ],

  "@type": { type: String, default: "ProductOrder" },
  "@baseType": { type: String, default: "Order" },
  "@schemaLocation": { type: String },
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});
PurchaseSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model("Purchase", PurchaseSchema);
