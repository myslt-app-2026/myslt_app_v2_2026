const validateBBPurchaseService = require("../services/validateBBPurchaseRequest.service");

exports.validateBBPurchaseRequest = async (req, res) => {
  try {
    const subscriberId = req.params.subscriberId || req.query.subscriberId;
    const packageId    = req.params.packageId    || req.query.packageId;
    const channel      = req.query.channel       || "MySLT";

    if (!subscriberId || !packageId) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "Missing required parameters: subscriberId and packageId",
        status:  "400",
        "@type": "Error",
      });
    }

    const result = await validateBBPurchaseService.validateBBPurchase(
      subscriberId,
      packageId,
      channel
    );

    return res.status(200).json({
      id:                  result.id,
      subscriberId:        result.subscriberId,
      packageId:           result.packageId,
      channel:             result.channel,
      state:               result.state,
      qualificationResult: result.qualificationResult,
      validationDate:      result.validationDate,
      "@type":             result["@type"],
    });

  } catch (error) {
    console.error("[ValidateBBPurchaseRequest] Error:", error);
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};