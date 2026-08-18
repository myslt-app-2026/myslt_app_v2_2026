const { bbUsageRequest } = require("../services/bbUsageRequestService");

const bbUsageRequestHandler = async (req, res) => {
  try {
    const result = await bbUsageRequest(req.body);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: "Internal Server Error"
    });
  }
};

module.exports = {
  bbUsageRequestHandler
};