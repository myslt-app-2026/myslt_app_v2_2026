const DataTransferAmount = require("../models/dataTransferAmount");

exports.getDataTransferAmounts = async (req, res) => {
  try {
    const { subscriberID } = req.query;
    if (!subscriberID) {
      return res.status(400).json({ error: "subscriberID is required" });
    }

    const transfers = await DataTransferAmount.find({ subscriberID });
    const response = transfers.map((t) => t.toTMF());

    res.json({
      subscriberID,
      transfers: response,
    });
  } catch (error) {
    console.error("Error fetching data transfer amounts:", error);
    res.status(500).json({ error: "Server error" });
  }
};
