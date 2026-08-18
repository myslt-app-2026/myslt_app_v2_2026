const { getBonusDataBySubscriber } = require("../services/bonusDataService");

const bonusDataRequest = async (req, res) => {
  try {
    const { subscriberID } = req.query;

    if (!subscriberID) {
      return res.status(400).json({
        isSuccess: false,
        errorMessage: "subscriberID is required",
      });
    }

    const result = await getBonusDataBySubscriber(subscriberID);
    return res.status(200).json(result);
  } catch (error) {
    console.error("BonusDataRequest error:", error);
    return res.status(500).json({
      isSuccess: false,
      errorMessage: "Internal Server Error",
    });
  }
};

module.exports = { bonusDataRequest };
