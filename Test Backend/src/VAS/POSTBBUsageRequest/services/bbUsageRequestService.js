const UsageManagement = require("../../../models/TMF635_UsageManagement");

const bbUsageRequest = async (body = {}) => {
  const {
    accountNo,
    serviceNo,
    subscriberID,
    usageType,
    usageAmount
  } = body;

  if (!accountNo) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo is required"
    };
  }

  if (!serviceNo) {
    return {
      success: false,
      statusCode: 400,
      message: "serviceNo is required"
    };
  }

  if (!subscriberID) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID is required"
    };
  }

  try {
    const usageData = await UsageManagement.create({
      accountNo,
      serviceNo,
      subscriberID,
      usageType: usageType || "BROADBAND",
      usageAmount: usageAmount || 0,
      status: "ACTIVE"
    });

    return {
      success: true,
      statusCode: 201,
      message: "BB Usage Request saved successfully",
      data: usageData
    };
  } catch (error) {
    return {
      success: false,
      statusCode: 500,
      message: error.message
    };
  }
};

module.exports = {
  bbUsageRequest
};