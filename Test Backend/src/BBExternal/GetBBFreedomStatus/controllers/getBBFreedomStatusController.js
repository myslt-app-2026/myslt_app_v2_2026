const Product = require('../../../models/TMF637_Product');

exports.getBBFreedomStatus = async (req, res) => {
  try {
    const tpNo = req.query.tpNo;

    if (!tpNo) {
      return res.status(400).json({
        "@type": "Error",
        code:    "ERR_MISSING_PARAMS",
        reason:  "tpNo is required"
      });
    }

    const product = await Product.findOne({
      publicIdentifier: tpNo
    });

    if (!product) {
      return res.status(200).json({
        "@type":    "Product",
        id:         `bbfreedom-${tpNo}`,
        href:       `/tmf-api/productInventory/v4/product/bbFreedomStatus?tpNo=${encodeURIComponent(tpNo)}`,
        name:       "BB Freedom",
        status:     "Active",
        startDate:  "2026-01-15",
        terminationDate: "2027-01-15",
        productCharacteristic: [
          { name: "tpNo",          value: tpNo },
          { name: "freedomStatus", value: "Active" }
        ],
        relatedParty: [
          {
            "@type": "RelatedParty",
            id:      tpNo,
            role:    "subscriber"
          }
        ]
      });
    }

    return res.status(200).json({
      "@type":  "Product",
      id:       product._id,
      name:     product.name,
      status:   product.status,
      publicIdentifier: product.publicIdentifier,
      relatedParty:     product.relatedParty,
      "@baseType":      product["@baseType"],
    });

  } catch (err) {
    console.error("Error in getBBFreedomStatus:", err);
    return res.status(500).json({
      "@type":  "Error",
      code:     "ERR_INTERNAL",
      reason:   "Internal Server Error",
      message:  err.message
    });
  }
};