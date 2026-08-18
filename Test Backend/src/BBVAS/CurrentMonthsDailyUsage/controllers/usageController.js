const DailyUsage = require("../../../models/TMF635_UsageManagement");

exports.getUsageById = async (req, res) => {
  try {
    const { id } = req.params;
    const usage = await DailyUsage.findOne({ subscriberID: id });

    if (!usage) {
      return res.status(404).json({
        code:    "404",
        reason:  "Not Found",
        message: `Usage not found for id: ${id}`,
        status:  "404",
        "@type": "Error",
      });
    }

    return res.status(200).json({
      id:           usage._id,
      subscriberID: usage.subscriberID,
      volume:       usage.volume,
      unit:         usage.unit,
      status:       usage.status,
      category:     usage.category,
      channel:      usage.channel,
      createdAt:    usage.createdAt,
      "@type":      "Usage",
    });

  } catch (error) {
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};

exports.getUsageFiltered = async (req, res) => {
  try {
    const { id, 'usageDate.gte': startDate, 'usageDate.lte': endDate } = req.query;

    if (!id) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "Missing required parameter 'id'",
        status:  "400",
        "@type": "Error",
      });
    }

    const query = { subscriberID: id };

    if (startDate && endDate) {
      query.createdAt = { $gte: new Date(startDate), $lte: new Date(endDate) };
    } else if (startDate) {
      query.createdAt = { $gte: new Date(startDate) };
    } else if (endDate) {
      query.createdAt = { $lte: new Date(endDate) };
    }

    const usages = await DailyUsage.find(query);

    if (!usages || usages.length === 0) {
      return res.status(404).json({
        code:    "404",
        reason:  "Not Found",
        message: `Usage not found for id: ${id}`,
        status:  "404",
        "@type": "Error",
      });
    }

    return res.status(200).json(usages);

  } catch (error) {
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};