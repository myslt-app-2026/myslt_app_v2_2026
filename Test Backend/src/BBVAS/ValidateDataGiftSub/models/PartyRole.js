const mongoose = require("mongoose");

const PartyRoleSchema = new mongoose.Schema(
  {
    id:     { type: String, required: true, unique: true },
    role:   { type: String, required: true },
    name:   { type: String },
    status: { type: String, default: "active" },
    engagedParty: {
      id:              { type: String },
      name:            { type: String },
      "@referredType": { type: String },
      "@type":         { type: String }
    },
    validFor: {
      startDateTime: { type: Date },
      endDateTime:   { type: Date }
    },
    "@type":     { type: String, default: "PartyRole" },
    "@baseType": { type: String }
  },
  {
    timestamps: true,
    versionKey: false,
    strict: false
  }
);

module.exports = mongoose.models.PartyRole ||
  mongoose.model("PartyRole", PartyRoleSchema);