const Invoice = require("../../../models/TMF678_CustomerBillManagement");

const updateSaveInvoice = async (body = {}) => {
  const { accountNo, tpNo, billId, billStatus, smsServiceStatus, status } = body;

  if (!accountNo || !tpNo) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo and tpNo are required",
    };
  }

  const invoice = await Invoice.findOneAndUpdate(
    { accountNo, tpNo },
    {
      $set: {
        billId,
        billStatus: billStatus || "PENDING",
        smsServiceStatus: smsServiceStatus || "INACTIVE",
        status: status || "active",
      },
    },
    { new: true }
  );

  if (!invoice) {
    return {
      success: false,
      statusCode: 404,
      message: "Invoice record not found",
    };
  }

  return {
    success: true,
    statusCode: 200,
    data: invoice,
  };
};

module.exports = { updateSaveInvoice };