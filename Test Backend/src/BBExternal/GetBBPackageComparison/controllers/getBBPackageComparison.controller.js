const ProductOffering = require("../../../../src/models/TMF620_ProductOffering");

/**
 * GET GetBBPackageComparison
 * /api/BBExternal/GetBBPackageComparison?type=ADSL&package=WEB FAMILY PLUS
 */
exports.getBBPackageComparison = async (req, res) => {
  try {
    const { type, package: packageName } = req.query;

    if (!type) {
      return res.status(400).json({
        code: "400",
        reason: "Missing mandatory query parameter: type"
      });
    }

    const filter = {
      category: "broadband",
      offeringType: type
    };

    if (packageName && packageName !== "Any") {
      filter.name = packageName;
    }

    const packages = await ProductOffering.find(filter);

    if (!packages || packages.length === 0) {
      return res.status(404).json({
        code: "404",
        reason: "No matching broadband packages found"
      });
    }

    res.status(200).json({
      totalCount: packages.length,
      comparison: packages,
      "@type": "ProductOfferingComparison"
    });

  } catch (err) {
    res.status(500).json({
      code: "500",
      reason: "Internal Server Error",
      message: err.message
    });
  }
};
