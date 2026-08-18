const { getPurchaseHistory } = require("../services/getPurchaseHistoryService");

const getPurchaseHistoryRequest = async (req, res) => {
  try {
    const { historyFrom, historyTo, subscriberID } = req.query;

    if (!subscriberID) {
      return res.status(400).json({
        isSuccess: false,
        errorMessage: "subscriberID is required",
      });
    }

    const result = await getPurchaseHistory({
      subscriberID,
      historyFrom,
      historyTo,
    });

    return res.status(200).json(result);
  } catch (error) {
    console.error("GetPurchaseHistory error:", error);
    return res.status(500).json({
      isSuccess: false,
      errorMessage: "Internal Server Error",
    });
  }
};

module.exports = { getPurchaseHistoryRequest };
