const CustomerBill = require("../../../models/TMF678_CustomerBillManagement");

const getPaymentLogs = async (query = {}) => {

  const { accountNo } = query;

  if (!accountNo) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo is required"
    };
  }

  const logs = await CustomerBill.find({ accountNo });

  return {
    success: true,
    statusCode: 200,
    data: logs
  };
};

module.exports = { getPaymentLogs };