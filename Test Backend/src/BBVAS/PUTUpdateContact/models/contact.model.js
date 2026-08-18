const mongoose = require("mongoose");

const addressSchema = new mongoose.Schema({
  street: String,
  city: String,
  country: String,
});

const contactSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  partyId: { type: String, required: true },
  contactType: { type: String, required: true }, // email, mobile, postal
  emailAddress: String,
  phoneNumber: String,
  address: addressSchema,
  preferred: { type: Boolean, default: false },
  status: { type: String, default: "active" },
});

module.exports = mongoose.model("Contact", contactSchema);
