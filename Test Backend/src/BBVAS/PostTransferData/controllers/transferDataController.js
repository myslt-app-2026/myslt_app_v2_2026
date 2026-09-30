const TMF635TransferData = require("../../../models/TMF635_UsageManagement");

exports.transferData = async (req, res) => {
  try {
    const subscriberID = req.body.subscriberID || req.body.accountNumber || "0312241780";
    const receiver = req.body.receiver || req.body.recipientMobile;
    const volume = req.body.volume || req.body.amountGB;
    const category = req.body.category || "DataTransfer";
    const channel = req.body.channel || "MYSLT_APP";

    if (!receiver || !volume) {
      return res.status(400).json({
        success: false,
        message: "recipientMobile (or receiver) and amountGB (or volume) are required",
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
