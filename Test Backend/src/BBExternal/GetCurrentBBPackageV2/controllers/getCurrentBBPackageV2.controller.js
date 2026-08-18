const Product = require("../../../models/TMF637_Product");
const ProductOffering = require("../../../models/TMF620_ProductOffering");

/**
 * GET GetCurrentBBPackageV2
 * /BBExternal/GetCurrentBBPackageV2?type=ADSL&package=UNLIMITED 2&customerId=CUST123
 */
exports.getCurrentBBPackageV2 = async (req, res) => {
  try {
    const { customerId, type, package: packageName } = req.query;

    if (!customerId) {
      return res.status(400).json({
        code: "400",
        reason: "Missing mandatory query parameter: customerId"
      });
    }

    // Build filter for Product (inventory)
    const productFilter = {
      customerId: customerId,
      category: "broadband",
      status: "Active"
    };

    // Find customer's active product
    let product = await Product.findOne(productFilter).populate("productOfferingId");

    if (!product) {
      return res.status(404).json({
        code: "404",
        reason: "No active broadband package found"
      });
    }

    // Optionally filter by type and package name
    if (type || packageName) {
      const po = await ProductOffering.findOne({
        _id: product.productOfferingId._id,
        ...(type && { offeringType: type }),
        ...(packageName && { name: packageName })
      });

      if (!po) {
        return res.status(404).json({
          code: "404",
          reason: "Active broadband package does not match type/package filter"
        });
      }

      product = { ...product.toObject(), productOfferingId: po };
    }

    res.status(200).json(product);

  } catch (err) {
    res.status(500).json({
      code: "500",
      reason: "Internal Server Error",
      message: err.message
    });
  }
};
