const addVASDataBundleService = require("../services/addVASDataBundleService");

const addVASDataBundle = async (req, res) => {
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

    const response = await addVASDataBundleService.addVASDataBundle(
      req.body,
      subscriberid
    );

    return res.status(201).json(response);
  } catch (error) {
    console.error("Add VAS Data Bundle error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  addVASDataBundle,
};