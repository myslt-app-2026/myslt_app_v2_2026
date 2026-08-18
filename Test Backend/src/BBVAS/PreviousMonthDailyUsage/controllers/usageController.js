const Usage = require("../models/usageModel");

// 🔹 GET usages (by subscriber & month)
exports.getPreviousMonthsDailyUsage = async (req, res) => {
  try {
    const { subscriberID, billDate, monthIndex } = req.query;

    if (!subscriberID || !billDate || !monthIndex) {
      return res.status(400).json({
        code: "400",
        reason: "Bad Request",
        message: "subscriberID, billDate and monthIndex are required",
        status: 400,
      });
    }

    const usages = await Usage.find({
      "relatedParty.id": subscriberID,
    });

    const response = usages.map((usage) => usage.toTMF635());

    return res.status(200).json({
      "@type": "UsageList",
      subscriberID,
      billDate,
      monthIndex,
      usage: response,
    });
  } catch (error) {
    return res.status(500).json({
      code: "500",
      reason: "Internal Server Error",
      message: error.message,
      status: 500,
    });
  }
};
