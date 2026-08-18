const {
  TMF678_CustomerBill
} = require("../../../models/TMF678_CustomerBill");

const getEbillDashboard = async (query) => {

  const { startDate, endDate } = query;

  const filter = {};

  if (startDate && endDate) {

    filter.billDate = {
      $gte: new Date(startDate),
      $lte: new Date(endDate)
    };

  }

  const data =
    await TMF678_CustomerBill.find(filter);

  return {
    success: true,
    statusCode: 200,
    totalRecords: data.length,
    data
  };

};

module.exports = {
  getEbillDashboard
};