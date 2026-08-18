const Invoice = require("../../../models/TMF678_CustomerBillManagement");

const bulkUpdateInvoiceData = async (body = {}) => {
  const { invoices } = body;

  if (!Array.isArray(invoices) || invoices.length === 0) {
    return {
      success: false,
      statusCode: 400,
      message: "invoices array is required",
    };
  }

  const result = await Promise.all(
    invoices.map((item) => {
      const { accountNo, tpNo, billId, billStatus, smsServiceStatus, status } = item;

      return Invoice.findOneAndUpdate(
        { accountNo, tpNo },
        {
          $set: {
            billId,
            billStatus: billStatus || "PENDING",
            smsServiceStatus: smsServiceStatus || "INACTIVE",
            status: status || "active",
          },
        },
        { new: true, upsert: true }
      );
    })
  );

  return {
    success: true,
    statusCode: 200,
    data: result,
  };
};

module.exports = { bulkUpdateInvoiceData };