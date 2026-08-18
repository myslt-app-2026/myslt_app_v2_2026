const Usage = require("../../../models/TMF635_UsageManagement");
const moment = require("moment");

exports.getWeeklyUsage = async (req, res) => {
  try {
    const subscriberId = req.params.subscriberId;

    const dailyRecords = await Usage.find({
      subscriberID: subscriberId,
      category: "DailyDataUsage"
    }).lean();

    if (!dailyRecords.length) {
      return res.status(404).json({
        code:    "404",
        reason:  "Not Found",
        message: "No usage found for subscriber",
        status:  "404",
        "@type": "Error",
      });
    }

    const weeklyGroups = {};
    dailyRecords.forEach((record) => {
      const week = moment(record.createdAt).isoWeek();
      if (!weeklyGroups[week]) {
        weeklyGroups[week] = { total: 0, days: [] };
      }
      weeklyGroups[week].total += record.volume || 0;
      weeklyGroups[week].days.push(record);
    });

    const weeklyUsages = Object.keys(weeklyGroups).map((week) => {
      const group = weeklyGroups[week];
      return {
        id:     `weekly-${subscriberId}-week${week}`,
        href:   `/usage/weekly/${subscriberId}/week${week}`,
        date:   new Date(),
        type:   "WeeklyDataUsage",
        status: "calculated",
        usageCharacteristic: [
          { name: "subscriberId",      value: subscriberId },
          { name: "weekNumber",        value: parseInt(week) },
          { name: "totalWeeklyUsage",  value: group.total.toFixed(2) },
          { name: "unit",              value: "GB" },
        ],
        "@type": "Usage",
      };
    });

    return res.status(200).json(weeklyUsages);

  } catch (err) {
    console.error(err);
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: err.message,
      status:  "500",
      "@type": "Error",
    });
  }
};