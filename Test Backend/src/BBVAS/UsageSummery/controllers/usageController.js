const Usage = require("../../../models/TMF635_UsageManagement");

exports.getUsageById = async (req, res) => {
  try {
    const { id } = req.params;
    const baseUrl = `${req.protocol}://${req.get("host")}`;

    const usage = await Usage.findOne({ subscriberID: id });
    if (!usage) {
      return res.status(404).json({
        code:    "404",
        reason:  "Not Found",
        message: `Usage with id=${id} not found`,
        status:  "404",
        "@type": "Error",
      });
    }

    return res.status(200).json({
      id:          usage._id,
      href:        `${baseUrl}/tmf-api/usageManagement/v4/usage/${usage._id}`,
      subscriberID: usage.subscriberID,
      status:      usage.status,
      volume:      usage.volume,
      unit:        usage.unit,
      category:    usage.category,
      channel:     usage.channel,
      "@type":     "Usage",
      "@baseType": "Entity",
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