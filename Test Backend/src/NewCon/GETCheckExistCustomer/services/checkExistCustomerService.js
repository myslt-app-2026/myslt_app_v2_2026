const CustomerBill = require("../../../models/TMF678_CustomerBillManagement");

const checkExistCustomer = async (query) => {
  const { accountNo } = query;

  if (!accountNo) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo is required",
    };
  }

  const customer = await CustomerBill.findOne({
    accountNo,
  });

  if (!customer) {
    return {
      success: false,
      statusCode: 404,
      message: "Customer not found",
    };
  }

  return {
    success: true,
    statusCode: 200,
    message: "Customer found",
    data: customer,
  };
};

module.exports = { checkExistCustomer };