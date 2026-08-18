const {
  getWeeksUsage,
} = require("./../Service/weeksUsageService");

const weeksUsageRequest = async (req, res) => {
  try {
    const result = await getWeeksUsage();

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("WeeksUsage error:", error);

    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: "Internal Server Error",
    });
  }
};

module.exports = {
  weeksUsageRequest,
};