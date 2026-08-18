const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getProtocolReport = async (query = {}) => {

  const { date } = query;

  if (!date) {
    return {
      success: false,
      statusCode: 400,
      message: "date is required"
    };
  }

  const reportDate = new Date(date);

  if (isNaN(reportDate.getTime())) {
    return {
      success: false,
      statusCode: 400,
      message: "Invalid date format"
    };
  }

  const startDate = new Date(
    reportDate.getFullYear(),
    reportDate.getMonth(),
    reportDate.getDate()
  );

  const endDate = new Date(startDate);
  endDate.setDate(endDate.getDate() + 1);

  const data = await UsageManagement.find({
    createdAt: {
      $gte: startDate,
      $lt: endDate
    }
  });

  return {
    success: true,
    statusCode: 200,
    count: data.length,
    data
  };
};

module.exports = {
  getProtocolReport
};