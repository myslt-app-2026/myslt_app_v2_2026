const TMF635UsageManagement = require("../models/TMF635_UsageManagement");

exports.getDataTransferAmounts = async (req, res) => {
  try {
    const { subscriberID } = req.query;

    if (!subscriberID) {
      return res.status(400).json({
        success: false,
        message: "subscriberID is required",
      });
    }

    const transfers = await TMF635UsageManagement.find({ subscriberID });
    const response = transfers.map((item) => item.toTMF());

    return res.status(200).json({
      success: true,
      subscriberID,
      transfers: response,
    });
  } catch (error) {
    console.error("Error fetching data transfer amounts:", error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};