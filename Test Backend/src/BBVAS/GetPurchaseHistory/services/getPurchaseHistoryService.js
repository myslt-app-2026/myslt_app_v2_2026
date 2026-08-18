const GetPurchaseHistory = require("../models/getPurchaseHistoryModel");

const getPurchaseHistory = async ({ subscriberID, historyFrom, historyTo }) => {
  const query = {};

  if (subscriberID) {
    query.subscriberID = subscriberID;
  }

  if (historyFrom || historyTo) {
    query.createdAt = {};

    if (historyFrom) {
      query.createdAt.$gte = new Date(historyFrom);
    }

    if (historyTo) {
      query.createdAt.$lte = new Date(historyTo);
    }
  }

  const data = await GetPurchaseHistory.find(query).lean();

  return {
    isSuccess: true,
    subscriberID,
    historyFrom,
    historyTo,
    count: data.length,
    data,
  };
};

module.exports = { getPurchaseHistory };
