const mongoose = require("mongoose");

const TMF679_ProductOfferingSchema = new mongoose.Schema(
  {
    id:                  { type: String, required: true, unique: true },
    subscriberId:        { type: String, required: true },
    packageId:           { type: String, required: true },
    channel:             { type: String, default: "MySLT" },
    state: {
      type: String,
      enum: ["qualified", "unqualified", "pending"],
      default: "pending",
    },
    qualificationResult: { type: String },
    validationDate:      { type: Date, default: Date.now },
    "@type":             { type: String, default: "ProductOfferingQualification" },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = mongoose.model(
  "TMF679_ProductOffering", 
  TMF679_ProductOfferingSchema
);