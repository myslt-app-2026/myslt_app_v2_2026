const VasBundleConfirm = require("../models/VasBundleConfirm.model");

/**
 * POST - Add VAS Data Bundle - Prepaid Confirm
 */
exports.addVasBundleConfirm = async (req, res) => {
  try {
    const body = req.body || {};

    const { purchaseID, payId, pgResponseCode, data } = body;

    if (!purchaseID || !payId || !pgResponseCode || !data) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields",
        debug: {
          receivedBody: req.body,
          contentType: req.headers["content-type"]
        }
      });
    }

    const savedRecord = await VasBundleConfirm.create({
      purchaseID,
      payId,
      pgResponseCode,
      data
    });

    return res.status(201).json({
      success: true,
      message: "VAS Data Bundle confirmation saved",
      data: savedRecord
    });
  } catch (error) {
    console.error("VAS Bundle Confirm Error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};
