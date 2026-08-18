const service =
require("../services/getVASDataBundlePackagesService");

exports.getVASDataBundlePackages =
async (req, res) => {

  try {

    const data =
    await service.getVASDataBundlePackages();

    if (!data || data.length === 0) {

      return res.status(404).json({

        "@type": "Error",
        code: "404",
        reason: "No VAS Data Bundle Packages Found"

      });

    }

    return res.status(200).json(data);

  } catch (error) {

    return res.status(500).json({

      "@type": "Error",
      code: "500",
      reason: error.message

    });

  }

};