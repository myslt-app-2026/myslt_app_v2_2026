const CustomerBill = require("../../../models/TMF678_CustomerBillManagement");

const getFTTHMapData = async (query) => {
  const { startDate, endDate } = query;

  const filter = {};

  if (startDate && endDate) {
    filter.createdAt = {
      $gte: new Date(startDate),
      $lte: new Date(endDate),
    };
  }

  const data = await CustomerBill.find(filter);

  return {
    success: true,
    statusCode: 200,
    totalRecords: data.length,
    data,
  };
};

module.exports = { getFTTHMapData };