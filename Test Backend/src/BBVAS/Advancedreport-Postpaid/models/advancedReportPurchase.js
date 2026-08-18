const mongoose = require("mongoose");

const advancedReportPurchaseSchema = new mongoose.Schema({
  subscriberID: { type: String, required: true },
  reporterPackage: { type: Number, required: true }, // Package ID
  activatedBy: { type: String, required: true },
  status: { type: String, default: "pending" }, // pending / activated / failed
  purchasedAt: { type: Date, default: Date.now },
});

advancedReportPurchaseSchema.methods.toTMF = function () {
  return {
    id: this._id,
    href: `http://localhost:5000/tmf-api/usageManagement/v4/AdvancedReports/${this._id}`,
    subscriberID: this.subscriberID,
    reporterPackage: this.reporterPackage,
    activatedBy: this.activatedBy,
    status: this.status,
    purchasedAt: this.purchasedAt,
  };
};

module.exports = mongoose.model(
  "AdvancedReportPurchase",
  advancedReportPurchaseSchema
);
