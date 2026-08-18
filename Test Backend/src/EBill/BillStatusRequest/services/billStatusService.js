const CustomerBillManagement = require("../../../models/TMF678_CustomerBillManagement");

const checkBillStatus = async (accountNo, tpNo) => {
  const record = await CustomerBillManagement.findOne({ accountNo, tpNo });

  if (!record) {
    return {
      isSuccess: false,
      statusCode: 404,
      errorMessage: "Bill status record not found"
    };
  }

  return {
    isSuccess: true,
    statusCode: 200,
    accountNo: record.accountNo,
    tpNo: record.tpNo,
    billId: record.billId,
    billStatus: record.billStatus,
    status: record.status
  };
};

module.exports = { checkBillStatus };