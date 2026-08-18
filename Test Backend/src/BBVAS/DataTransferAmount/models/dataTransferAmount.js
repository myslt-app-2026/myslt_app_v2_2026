const mongoose = require("mongoose");

const dataTransferAmountSchema = new mongoose.Schema({
  subscriberID: { type: String, required: true },
  transferType: { type: String, required: true }, // e.g., gift, bonus
  maxAmount: { type: Number, required: true }, // MB/GB
  remainingAmount: { type: Number, required: true },
  unit: { type: String, default: "MB" },
  createdAt: { type: Date, default: Date.now },
});

dataTransferAmountSchema.methods.toTMF = function () {
  return {
    subscriberID: this.subscriberID,
    transferType: this.transferType,
    maxAmount: this.maxAmount,
    remainingAmount: this.remainingAmount,
    unit: this.unit,
  };
};

module.exports = mongoose.model("DataTransferAmount", dataTransferAmountSchema);
