const EnhancedCurrentDailyUsage = require('../models/EnhancedCurrentDailyUsageModel');

// GET Enhanced Current Daily Usage
exports.getEnhancedCurrentDailyUsage = async (req, res) => {
  try {
    const { subscriberID, billDate } = req.query;

    if (!subscriberID || !billDate) {
      return res.status(400).json({ error: "subscriberID and billDate are required" });
    }

    const usageData = await EnhancedCurrentDailyUsage.findOne({ subscriberID, billDate });

    if (!usageData) {
      return res.status(404).json({ message: "No usage data found" });
    }

    res.json({
      id: usageData.id,
      href: `/tmf-api/usageManagement/v4/usage/${usageData.id}`,
      usageDate: usageData.usageDate,
      description: usageData.description || "Daily usage record",
      usageType: usageData.usageType || "Data",
      status: usageData.status,
      usageCharacteristic: usageData.usageCharacteristic,
      relatedParty: usageData.relatedParty,
      usageSpecification: usageData.usageSpecification
    });

  } catch (error) {
    res.status(500).json({ error: "Server error", details: error.message });
  }
};
