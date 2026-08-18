const TMF635TransferData = require("../../../models/TMF635_UsageManagement");

exports.transferData = async (req, res) => {
  try {
    const { subscriberID, receiver, volume, category, channel } = req.body;

    if (!subscriberID || !receiver || !volume || !category || !channel) {
      return res.status(400).json({
        success: false,
        message: "subscriberID, receiver, volume, category and channel are required",
      });
    }

    const transferRecord = new TMF635TransferData({
      subscriberID,
      receiver,
      volume,
      category,
      channel,
      status: "completed",
    });

    await transferRecord.save();

    return res.status(201).json({
      success: true,
      message: "Data transferred successfully",
      data: transferRecord,
    });
  } catch (error) {
    console.error("Error transferring data:", error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};
