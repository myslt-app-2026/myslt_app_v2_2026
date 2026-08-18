const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getWeeksUsage = async () => {

  const currentDate = new Date();

  const weekAgo = new Date();

  weekAgo.setDate(currentDate.getDate() - 7);

  const data = await UsageManagement.find({
    createdAt: {
      $gte: weekAgo,
      $lte: currentDate,
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
  getWeeksUsage,
};