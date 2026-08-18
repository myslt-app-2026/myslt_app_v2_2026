const UsageManagement = require("../../../models/TMF635_UsageManagement");

const validateDataTransferSub = async (query) => {

  const { subscriberID, receiver } = query;

  if (!subscriberID || !receiver) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID and receiver are required"
    };
  }

  // check sender exists
  const sender = await UsageManagement.findOne({ subscriberID });

  if (!sender) {
    return {
      success: false,
      statusCode: 404,
      message: "Sender subscriber not found"
    };
  }

  // check receiver exists
  const receiverUser = await UsageManagement.findOne({ subscriberID: receiver });

  if (!receiverUser) {
    return {
      success: false,
      statusCode: 404,
      message: "Receiver subscriber not found"
    };
  }

  // check sender has remaining data
  if (sender.remainingAmount <= 0) {
    return {
      success: false,
      statusCode: 400,
      message: "No remaining data to transfer"
    };
  }

  return {
    success: true,
    statusCode: 200,
    message: "Validation successful",
    data: {
      sender: subscriberID,
      receiver,
      remainingAmount: sender.remainingAmount,
      unit: sender.unit
    }
  };
};

module.exports = { validateDataTransferSub };