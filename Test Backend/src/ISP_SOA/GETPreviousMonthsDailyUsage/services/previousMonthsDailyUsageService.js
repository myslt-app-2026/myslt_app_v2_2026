const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getPreviousMonthsDailyUsage = async (query) => {

  const { billDate } = query;

  if (!billDate) {
    return {
      success: false,
      statusCode: 400,
      message: "billDate is required"
    };
  }

  const data = await UsageManagement.find({
    createdAt: {
      $lt: new Date(billDate)
    }
  });

  return {
    success: true,
    statusCode: 200,
    count: data.length,
    data
  };
};

module.exports = { getPreviousMonthsDailyUsage };