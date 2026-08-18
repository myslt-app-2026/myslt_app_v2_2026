const Customer = require("../../../models/TMF629_Customer");
const Service = require("../../../models/TMF638_ServiceModel");
const PartyRole = require("../models/PartyRole");

exports.validateDataGiftSub = async (req, res) => {
  try {
    const subscriberId = req.params.subscriberId || req.query.subscriberId;
    const giftId = req.params.giftId || req.query.giftId;
    const sponsorId = req.params.sponsorId || req.query.sponsorId;

    if (!subscriberId || !giftId || !sponsorId) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "Missing subscriberId, giftId, or sponsorId",
        status:  "400",
        "@type": "Error",
      });
    }

    // Step 1: Validate customer using TMF629
    const customer = await Customer.findOne({ id: subscriberId }).lean();

    if (!customer || customer.status !== "Approved") {
      return res.status(404).json({
        code:    "404",
        reason:  "Not Found",
        message: "Invalid or inactive subscriber",
        status:  "404",
        "@type": "Error",
      });
    }

    // Step 2: Validate service
    const service = await Service.findOne({ id: giftId });
    if (!service || service.state !== "active") {
      return res.status(400).json({
        code:    "400",
        reason:  "Bad Request",
        message: "Invalid or inactive DataGift service",
        status:  "400",
        "@type": "Error",
      });
    }

    // Step 3: Validate sponsor role
    const sponsor = await PartyRole.findOne({ id: sponsorId, role: "Sponsor" });
    if (!sponsor) {
      return res.status(400).json({
        code:    "400",
        reason:  "Bad Request",
        message: "Invalid sponsor role",
        status:  "400",
        "@type": "Error",
      });
    }

    // Success
    return res.status(200).json({
      status:     "success",
      subscriber: customer,
      service,
      sponsor,
      "@type":    "ValidateDataGiftSub",
    });

  } catch (err) {
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: err.message,
      status:  "500",
      "@type": "Error",
    });
  }
};