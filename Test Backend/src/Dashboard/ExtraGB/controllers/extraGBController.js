const axios = require("axios");

const EXTERNAL_BASE_URL = "http://10.68.74.136:8081";

exports.getExtraGB = async (req, res) => {
  try {
    const { subscriberId } = req.query;

    if (!subscriberId) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "subscriberId is required",
        status:  "400",
        "@type": "Error",
      });
    }

    try {
      const response = await axios.get(
        `${EXTERNAL_BASE_URL}/dashboard/extragb`,
        {
          params:  { subscriberId },
          timeout: 10000,
        }
      );
      return res.status(200).json(response.data);

    } catch (externalError) {
      return res.status(200).json({
        subscriberId: subscriberId,
        extraGB:      "2GB",
        status:       "active",
        expiryDate:   "2026-06-30",
        "@type":      "ExtraGB",
        note:         "Mock data - external server not reachable"
      });
    }

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