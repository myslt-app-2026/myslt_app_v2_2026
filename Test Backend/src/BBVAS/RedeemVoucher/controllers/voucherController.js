const TMF635 = require("../../../models/TMF635_UsageManagement");

exports.redeemVoucher = async (req, res) => {
  try {
    const { subscriberID, voucherid, channel } = req.query;

    if (!subscriberID || !voucherid || !channel) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "Missing required parameters: subscriberID, voucherid, channel",
        status:  "400",
        "@type": "Error",
      });
    }

    const bonusData = 1024;

    const redeem = new TMF635({
      subscriberID,
      voucherID:  voucherid,
      channel,
      status:     "redeemed",
      volume:     bonusData,
      unit:       "MB",
      category:   "VoucherRedeem",
    });

    await redeem.save();

    return res.status(201).json({
      subscriberID: redeem.subscriberID,
      voucherID:    redeem.voucherID,
      channel:      redeem.channel,
      status:       redeem.status,
      bonusData:    redeem.volume,
      unit:         redeem.unit,
      redeemedAt:   redeem.createdAt,
      "@type":      "Usage",
    });

  } catch (error) {
    console.error("Error redeeming voucher:", error);
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};