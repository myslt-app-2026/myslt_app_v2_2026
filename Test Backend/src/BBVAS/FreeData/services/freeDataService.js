const FreeData = require("../models/freeDataModel");

const getFreeDataBySubscriber = async (subscriberID) => {
  const query = {
    lifecycleStatus: { $regex: /^active$/i },
    $or: [
      { category: { $regex: /free/i } },
      { name: { $regex: /free/i } },
      { offeringType: { $regex: /free/i } },
    ],
  };

  const freeDataPackages = await FreeData.find(query).lean();

  return {
    isSuccess: true,
    subscriberID,
    count: freeDataPackages.length,
    data: freeDataPackages,
  };
};

module.exports = { getFreeDataBySubscriber };
