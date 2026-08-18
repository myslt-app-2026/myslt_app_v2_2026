const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getPreviousMonthsDailyUsage = async (query = {}) => {
  const { billDate } = query;

  if (!billDate) {
    return {
      success: false,
      statusCode: 400,
      message: "billDate is required",
    };
  }

  const selectedDate = new Date(billDate);

  const startDate = new Date(
    selectedDate.getFullYear(),
    selectedDate.getMonth() - 1,
    1
  );

  const endDate = new Date(
    selectedDate.getFullYear(),
    selectedDate.getMonth(),
    0
  );

  const data = await UsageManagement.find({
    createdAt: {
      $gte: startDate,
      $lte: endDate,
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
  getPreviousMonthsDailyUsage,
};