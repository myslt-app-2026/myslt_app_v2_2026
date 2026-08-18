const getVASDataBundlePackagesService = require("../services/getVASDataBundlePackages.service");

exports.getVASDataBundlePackages = async (req, res) => {
  try {
    const packages = await getVASDataBundlePackagesService.getVASDataBundlePackages();

    if (!packages || packages.length === 0) {
      return res.status(404).json({
        code:    "404",
        reason:  "Not Found",
        message: "No VAS Data Bundle Packages found",
        status:  "404",
        "@type": "Error",
      });
    }

    return res.status(200).json(packages);

  } catch (error) {
    console.error("[GetVASDataBundlePackages] Error:", error);
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};