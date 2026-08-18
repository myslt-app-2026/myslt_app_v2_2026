const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getCurrentMonthDailyUsage = async (query = {}) => {
  const { billDate } = query;

  if (!billDate) {
    return {
      success: false,
      statusCode: 400,
      message: "billDate is required",
    };
  }

  const date = new Date(billDate);

  if (isNaN(date.getTime())) {
    return {
      success: false,
      statusCode: 400,
      message: "Invalid billDate format",
    };
  }

  const startDate = new Date(
    date.getFullYear(),
    date.getMonth(),
    1
  );

  const data = await UsageManagement.find({
    createdAt: {
      $gte: startDate,
    },
  });

  return {
    success: true,
    statusCode: 200,
    count: data.length,
    data,
  };
};

module.exports = {
  getCurrentMonthDailyUsage,
};