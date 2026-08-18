const mongoose = require("mongoose");

const TMF678CustomerBillManagementSchema = new mongoose.Schema(
  {
    accountNo: {
      type: String,
      required: true,
      trim: true
    },

    tpNo: {
      type: String,
      required: true,
      trim: true
    },

    billId: {
      type: String,
      default: null
    },

    billStatus: {
      type: String,
      default: "PENDING"
    },

    smsServiceStatus: {
      type: String,
      default: "INACTIVE"
    },

    status: {
      type: String,
      default: "active"
    }
  },
  {
    timestamps: true
  }
);

module.exports = mongoose.model(
  "TMF678_CustomerBillManagement",
  TMF678CustomerBillManagementSchema
);