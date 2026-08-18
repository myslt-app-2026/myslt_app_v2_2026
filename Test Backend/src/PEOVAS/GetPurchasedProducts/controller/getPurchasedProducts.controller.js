const PurchasedProduct = require('../../../../src/models/PEOVAS_purchasedProductmodel');

exports.getPurchasedProductsByTel = async (req, res, next) => {
  try {
    const { telephoneNo } = req.params;

    if (!telephoneNo) {
      return res.status(400).json({ error: "telephoneNo param is required" });
    }

    const results = await PurchasedProduct.find({ telephoneNo });

    res.status(200).json({
      count: results.length,
      data: results
    });

  } catch (error) {
    next(error);
  }
};
