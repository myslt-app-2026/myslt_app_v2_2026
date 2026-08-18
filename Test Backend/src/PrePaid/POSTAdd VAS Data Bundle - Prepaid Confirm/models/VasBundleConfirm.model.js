
const mongoose = require("mongoose");

const VasBundleConfirmSchema = new mongoose.Schema(
  {
    purchaseID: { type: String, required: true, index: true },
    payId: { type: String, required: true },
    pgResponseCode: { type: String, required: true },
    data: { type: String, required: true }
  },
  { timestamps: true }
);

module.exports = mongoose.model(
  "VasBundleConfirm",
  VasBundleConfirmSchema
);
