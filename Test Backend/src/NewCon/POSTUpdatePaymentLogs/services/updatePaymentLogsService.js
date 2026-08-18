const CustomerBill = require("../../../models/TMF678_CustomerBillManagement");

const updatePaymentLogs = async (body = {}) => {

  const {
    accountNo,
    billStatus
  } = body;

  if (!accountNo || !billStatus) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo and billStatus are required"
    };
  }

  const updated = await CustomerBill.findOneAndUpdate(
    { accountNo },
    { billStatus },
    { new: true }
  );

  if (!updated) {
    return {
      success: false,
      statusCode: 404,
      message: "Payment log not found"
    };
  }

  return {
    success: true,
    statusCode: 200,
    message: "Payment log updated successfully",
    data: updated
  };
};

module.exports = { updatePaymentLogs };