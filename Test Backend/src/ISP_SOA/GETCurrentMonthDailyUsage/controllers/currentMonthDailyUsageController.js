const {
  getCurrentMonthDailyUsage,
} = require("../services/currentMonthDailyUsageService");

const currentMonthDailyUsageRequest = async (req, res) => {
  try {
    const result = await getCurrentMonthDailyUsage(req.query);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("CurrentMonthDailyUsage error:", error);

    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: error.message,
    });
  }
};

module.exports = {
  currentMonthDailyUsageRequest,
};