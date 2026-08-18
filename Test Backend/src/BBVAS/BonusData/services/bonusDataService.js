const BonusData = require("../models/bonusDataModel");

const getBonusDataBySubscriber = async (subscriberID) => {
  const query = {
    lifecycleStatus: { $regex: /^active$/i },
    $or: [
      { category: { $regex: /bonus/i } },
      { name: { $regex: /bonus/i } },
      { offeringType: { $regex: /bonus/i } },
    ],
  };

  const bonusPackages = await BonusData.find(query).lean();

  return {
    isSuccess: true,
    subscriberID,
    count: bonusPackages.length,
    data: bonusPackages,
  };
};

module.exports = { getBonusDataBySubscriber };
