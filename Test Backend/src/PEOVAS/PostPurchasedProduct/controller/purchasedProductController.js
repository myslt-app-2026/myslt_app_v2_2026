const PurchasedProduct = require('../../../../src/models/PEOVAS_purchasedProductmodel');

/**
 * Create a Purchased Product
 * Supports both Query Parameters and JSON Body input
 */
exports.createPurchasedProduct = async (req, res, next) => {
  try {
    // Accept params from either query or body
    const telephoneNo = req.query.telephoneNo || req.body.telephoneNo;
    const productid = req.query.productid || req.body.productid;
    const pin = req.query.pin || req.body.pin;

    // Input validation
    const missingFields = [];
    if (!telephoneNo) missingFields.push("telephoneNo");
    if (!productid) missingFields.push("productid");
    if (!pin) missingFields.push("pin");

    if (missingFields.length > 0) {
      return res.status(400).json({
        error: "Missing required fields",
        missing: missingFields
      });
    }

    // Save to DB
    const purchasedProduct = new PurchasedProduct({ telephoneNo, productid, pin });
    await purchasedProduct.save();

    return res.status(201).json({
      message: "Purchased product created successfully",
      data: purchasedProduct
    });

  } catch (error) {
    next(error); // Pass to centralized error handler
  }
};
