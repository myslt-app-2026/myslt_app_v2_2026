const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getWeeksUsage = async () => {
  const sevenDaysAgo = new Date();

  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  const data = await UsageManagement.find({
    createdAt: {
      $gte: sevenDaysAgo,
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