const vasBundleUnsubscriptionService = require("../services/vasBundleUnsubscriptionService");

const unsubscribeVASBundle = async (req, res) => {
  try {
    const subscriberid = req.headers.subscriberid;
    const { packageId, bundleId, offerCode } = req.body;

    if (!subscriberid) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberid header is required",
      });
    }

    if (!packageId && !bundleId && !offerCode) {
      return res.status(400).json({
        error: "Bad Request",
        message: "packageId, bundleId or offerCode is required",
      });
    }

    const response =
      await vasBundleUnsubscriptionService.unsubscribeVASBundle(
        req.body,
        subscriberid
      );

    return res.status(200).json(response);
  } catch (error) {
    console.error("VAS Bundle Unsubscription error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  unsubscribeVASBundle,
};