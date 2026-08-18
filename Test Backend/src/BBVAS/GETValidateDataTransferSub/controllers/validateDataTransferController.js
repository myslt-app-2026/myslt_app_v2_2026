const UsageManagement = require("../../../models/TMF635_UsageManagement");

exports.validateDataTransferSub = async (req, res) => {
  try {

    const { subscriberID, receiver } = req.query;

    // validation
    if (!subscriberID || !receiver) {
      return res.status(400).json({
        success: false,
        message: "subscriberID and receiver are required"
      });
    }

    // check sender exists
    const sender = await UsageManagement.findOne({ subscriberID });

    if (!sender) {
      return res.status(404).json({
        success: false,
        message: "Sender subscriber not found"
      });
    }

    // check receiver exists
    const receiverUser = await UsageManagement.findOne({ subscriberID: receiver });

    if (!receiverUser) {
      return res.status(404).json({
        success: false,
        message: "Receiver subscriber not found"
      });
    }

    // check remaining data
    if (sender.remainingAmount <= 0) {
      return res.status(400).json({
        success: false,
        message: "No remaining data to transfer"
      });
    }

    // success
    return res.status(200).json({
      success: true,
      message: "Validation successful",
      data: {
        sender: subscriberID,
        receiver: receiver,
        remainingAmount: sender.remainingAmount,
        unit: sender.unit
      }
    });

  } catch (error) {

    return res.status(500).json({
      success: false,
      message: "Server error",
      error: error.message
    });

  }
};