const getVASBundlePackagesService = require("../services/getVASBundlePackagesService");

const getVASBundlePackages = async (req, res) => {
  try {
    const subscriberid = req.headers.subscriberid || req.query.subscriberid || req.query.subscriberID || "94112345678";
    const { basepackage } = req.query;

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