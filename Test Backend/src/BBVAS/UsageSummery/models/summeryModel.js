const mongoose = require("mongoose");

const usageCharacteristicSchema = new mongoose.Schema({
  name: { type: String, required: true },
  value: { type: String, required: true },
  valueType: { type: String, required: true },
});

const relatedPartySchema = new mongoose.Schema({
  id: { type: String, required: true },
  href: { type: String, required: true },
  role: { type: String },
  name: { type: String },
  "@referredType": { type: String },
});

const usageSchema = new mongoose.Schema({
  _id: { type: String, required: true },
  usageDate: { type: Date, required: true },
  description: { type: String },
  usageType: { type: String, required: true },
  status: { type: String, required: true },
  usageSpecification: {
    id: String,
    href: String,
    name: String,
    "@type": String,
    "@schemaLocation": String,
  },
  usageCharacteristic: [usageCharacteristicSchema],
  relatedParty: [relatedPartySchema],
});

// TMF aligned response method
usageSchema.methods.toTMF635 = function (baseUrl) {
  return {
    id: this._id,
    href: `${baseUrl}/tmf-api/usageManagement/v4/usage/${this._id}`,
    usageDate: this.usageDate,
    description: this.description,
    usageType: this.usageType,
    status: this.status,
    usageSpecification: this.usageSpecification,
    usageCharacteristic: this.usageCharacteristic,
    relatedParty: this.relatedParty,
    "@type": "Usage",
    "@baseType": "Entity",
    "@schemaLocation": `${baseUrl}/tmf-api/schema/Usage/Usage.schema.json`,
  };
};

const Usage = mongoose.model("SummeryUsage", usageSchema);

module.exports = Usage;
