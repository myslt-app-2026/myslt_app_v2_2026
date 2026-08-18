const { getFreeDataBySubscriber } = require("../services/freeDataService");

const freeDataRequest = async (req, res) => {
  try {
    const { subscriberID } = req.query;

    if (!subscriberID) {
      return res.status(400).json({
        isSuccess: false,
        errorMessage: "subscriberID is required",
      });
    }

    const result = await getFreeDataBySubscriber(subscriberID);
    return res.status(200).json(result);
  } catch (error) {
    console.error("FreeDataRequest error:", error);
    return res.status(500).json({
      isSuccess: false,
      errorMessage: "Internal Server Error",
    });
  }
};

module.exports = { freeDataRequest };
