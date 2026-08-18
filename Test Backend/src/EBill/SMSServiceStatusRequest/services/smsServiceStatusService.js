const CustomerBillManagement = require("../../../models/TMF678_CustomerBillManagement");

const checkSMSServiceStatus = async (accountNo, tpNo) => {
  const record = await CustomerBillManagement.findOne({ accountNo, tpNo });

  if (!record) {
    return {
      isSuccess: false,
      statusCode: 404,
      errorMessage: "SMS service status record not found"
    };
  }

  return {
    isSuccess: true,
    statusCode: 200,
    accountNo: record.accountNo,
    tpNo: record.tpNo,
    smsServiceStatus: record.smsServiceStatus,
    status: record.status
  };
};

module.exports = { checkSMSServiceStatus };