const ProductOffering = require("../../../../src/models/TMF620_ProductOffering");

/**
 * GET GetBBPackagesV2
 * /BBExternal/GetBBPackagesV2?type=SLT 4G&package=Any Tide
 */
exports.getBBPackagesV2 = async (req, res) => {
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
      lifecycleStatus: "Active",
      offeringType: type
    };

    if (packageName) {
      filter.name = packageName;
    }

    const offerings = await ProductOffering.find(filter);

    res.status(200).json({
      totalCount: offerings.length,
      productOfferings: offerings
    });

  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
