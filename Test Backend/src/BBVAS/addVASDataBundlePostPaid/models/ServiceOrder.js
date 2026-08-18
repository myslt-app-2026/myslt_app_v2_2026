const mongoose = require("mongoose");

const RelatedPartySchema = new mongoose.Schema({
  id: { type: String, required: true },   // SLT: subscriberID or commitUser
  role: { type: String, required: true }, // e.g., "customer", "initiator"
  name: { type: String },
  referredType: { type: String }
});

const ServiceSchema = new mongoose.Schema({
  id: { type: String },                  // SLT: packageId
  name: { type: String },                // e.g., "VAS Data Bundle"
  serviceType: { type: String, default: "DataBundle" },
  characteristics: { type: Map, of: String } // additional key-values if needed
});

const ServiceOrderItemSchema = new mongoose.Schema({
  id: { type: String, required: true },
  action: { type: String, enum: ["add", "modify", "delete"], default: "add" },
  state: {
    type: String,
    enum: ["acknowledged", "inProgress", "completed", "failed"],
    default: "acknowledged"
  },
  service: ServiceSchema
});

const ServiceOrderSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, 
  externalId: { type: String }, // optional external tracking ID
  priority: { type: String },
  description: { type: String, default: "VAS Data Bundle PostPaid Order" },
  category: { type: String, default: "VAS" },
  state: {
    type: String,
    enum: ["acknowledged", "inProgress", "completed", "failed", "cancelled"],
    default: "acknowledged"
  },
  orderDate: { type: Date, default: Date.now },
  requestedStartDate: { type: Date },
  requestedCompletionDate: { type: Date },
  completionDate: { type: Date },
  relatedParty: [RelatedPartySchema], // includes subscriberID + commitUser
  orderItem: [ServiceOrderItemSchema],
  channel: {
    id: { type: String },    // SLT: channel (e.g., MOBILE)
    name: { type: String }   // e.g., "MOBILE App"
  },
  note: [
    {
      text: String,
      author: String,
      date: { type: Date, default: Date.now }
    }
  ]
});

module.exports = mongoose.model("ServiceOrder", ServiceOrderSchema);
