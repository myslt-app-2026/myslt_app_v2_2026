const ProductOffering = require("../../../models/TMF620_ProductOffering");

exports.getDashboardVASBundles = async (req, res) => {
  try {
    const bundles = await ProductOffering.find({
      $or: [
        { category:     { $regex: /vas/i } },
        { offeringType: { $regex: /vas/i } },
        { name:         { $regex: /vas/i } }
      ],
      lifecycleStatus: "Active"
    });

    if (!bundles || bundles.length === 0) {
      return res.status(200).json([
        {
          id:              "VAS-2GB-7D",
          name:            "VAS Data Bundle 2GB",
          category:        "VAS",
          offeringType:    "VAS",
          lifecycleStatus: "Active",
          description:     "VAS Data Bundle 2GB for 7 Days",
          "@type":         "ProductOffering"
        },
        {
          id:              "VAS-5GB-30D",
          name:            "VAS Data Bundle 5GB",
          category:        "VAS",
          offeringType:    "VAS",
          lifecycleStatus: "Active",
          description:     "VAS Data Bundle 5GB for 30 Days",
          "@type":         "ProductOffering"
        }
      ]);
    }

    return res.status(200).json(bundles);

  } catch (error) {
    console.error("[GetDashboardVASBundles] Error:", error);
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};