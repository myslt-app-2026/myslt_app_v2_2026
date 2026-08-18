const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getExtraGB = async (query = {}) => {
  const { subscriberID } = query;

  if (!subscriberID) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID is required",
    };
  }

  const subscriber = await UsageManagement.findOne({
    subscriberID,
  });

  if (!subscriber) {
    return {
      success: false,
      statusCode: 404,
      message: "Subscriber not found",
    };
  }

  return {
    success: true,
    statusCode: 200,
    subscriberID: subscriber.subscriberID,
    extraGB: subscriber.remainingAmount || 0,
    unit: subscriber.unit || "MB",
  };
};

module.exports = {
  getExtraGB,
};