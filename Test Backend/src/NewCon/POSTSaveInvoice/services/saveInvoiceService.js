const Invoice = require("../../../models/TMF678_CustomerBillManagement");

const saveInvoice = async (body = {}) => {
  const { accountNo, tpNo, billId, billStatus, smsServiceStatus, status } = body;

  if (!accountNo || !tpNo) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo and tpNo are required",
    };
  }

  const invoice = await Invoice.create({
    accountNo,
    tpNo,
    billId,
    billStatus: billStatus || "SAVED",
    smsServiceStatus: smsServiceStatus || "INACTIVE",
    status: status || "active",
  });

  return {
    success: true,
    statusCode: 201,
    data: invoice,
  };
};

module.exports = { saveInvoice };