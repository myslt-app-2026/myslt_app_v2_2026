const mongoose = require("mongoose");

const contactMediumSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
  },
  mediumType: {
    type: String,
    enum: ["Email", "Mobile", "Landline"],
    required: true,
  },
  isDefault: {
    type: Boolean,
    default: false,
  },
  characteristic: {
    type: Object,
    required: true,
  },
});

const relatedPartySchema = new mongoose.Schema({
  id: String,
  href: String,
  name: String,
  role: String,
});

const customerSchema = new mongoose.Schema({
  id: {
    type: String,
    unique: true,
    required: true,
  },
  href: String,
  name: String,
  relatedParty: [relatedPartySchema],
  contactMedium: [contactMediumSchema],
  status: {
    type: String,
    enum: ["Active", "Inactive", "Pending"],
    default: "Active",
  },
  characteristic: {
    type: Object,
  },
});

const ISPContact = mongoose.model("ISPContact", customerSchema);
module.exports = ISPContact;