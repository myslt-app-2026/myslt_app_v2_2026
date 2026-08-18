const CustomerBill = require("../../../models/TMF678_CustomerBillManagement");

const getFTTHSpecificDataFilter = async (query) => {
  const { accountNo, billStatus, smsServiceStatus } = query;

  const filter = {};

  if (accountNo) {
    filter.accountNo = accountNo;
  }

  if (billStatus) {
    filter.billStatus = billStatus;
  }

  if (smsServiceStatus) {
    filter.smsServiceStatus = smsServiceStatus;
  }

  const data = await CustomerBill.find(filter);

  return {
    success: true,
    statusCode: 200,
    totalRecords: data.length,
    data,
  };
};

module.exports = { getFTTHSpecificDataFilter };