const getVASBundlePackagesService = require("../services/getVASBundlePackagesService");

const getVASBundlePackages = async (req, res) => {
  try {
    const subscriberid = req.headers.subscriberid;
    const { basepackage } = req.query;

    if (!subscriberid) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberid header is required",
      });
    }

    const response = await getVASBundlePackagesService.getVASBundlePackages(
      basepackage,
      subscriberid
    );

    return res.status(200).json(response);
  } catch (error) {
    console.error("Get VAS Bundle Packages error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  getVASBundlePackages,
};