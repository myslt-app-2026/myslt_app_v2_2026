const UsageManagement = require("../../../models/TMF635_UsageManagement");

const getDataTransferAmounts = async (query) => {

  const { subscriberID } = query;

  if (!subscriberID) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID is required"
    };
  }

  const data = await UsageManagement.find({
    subscriberID,
    status: "active"
  });

  if (!data || data.length === 0) {
    return {
      success: false,
      statusCode: 404,
      message: `No data transfer amounts found for subscriberID: ${subscriberID}`
    };
  }

  return {
    success: true,
    statusCode: 200,
    subscriberID,
    count: data.length,
    data
  };
};

module.exports = { getDataTransferAmounts };