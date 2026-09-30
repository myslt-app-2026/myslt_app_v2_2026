// controllers/productOfferingQualificationController.js
const ExtraGbBundle = require("../models/ExtraGbBundle");
const ProductOfferingQualification = require("../models/ProductOfferingQualification");

// POST /productOfferingQualification
exports.checkProductOfferingQualification = async (req, res) => {
  try {
    const relatedParty = req.body.relatedParty || [
      { id: req.body.accountNumber || "0312241780", role: "customer" }
    ];
    const checkProductOfferingQualificationItem = req.body.checkProductOfferingQualificationItem || [
      {
        id: "1",
        action: "add",
        product: { productSpecification: { name: req.body.basePackage || "Web Booster" } },
        category: { id: "ExtraGB" }
      }
    ];

    const subscriber = relatedParty[0];
    const requestItem = checkProductOfferingQualificationItem[0];
    const basePackage = (requestItem.product && requestItem.product.productSpecification)
      ? requestItem.product.productSpecification.name
      : "Web Booster";

    // Lookup bundles from local catalog
    let eligibleBundles = await ExtraGbBundle.find({
      allowedBasePackages: basePackage
    });

    if (!eligibleBundles || eligibleBundles.length === 0) {
      eligibleBundles = await ExtraGbBundle.find();
    }

    // Build TMF679-compliant response
    const response = {
      id: `POQ-${Date.now()}`,
      state: "done",
      effectiveQualificationDate: new Date(),
      relatedParty,
      checkProductOfferingQualificationItem: [
        {
          id: requestItem.id,
          action: requestItem.action,
          product: requestItem.product,
          category: requestItem.category,
          qualificationItemResult: eligibleBundles.length > 0 ? "qualified" : "unqualified",
          eligibleProductOffering: eligibleBundles.map(bundle => ({
            id: bundle.packageId.toString(),
            name: bundle.name,
            productSpecification: { name: "Data Add-on" },
            productPrice: [
              {
                priceType: "recurring",
                price: {
                  amount: bundle.price.amount,
                  currency: bundle.price.currency
                },
                taxIncludedAmount: {
                  amount: bundle.taxIncludedAmount,
                  currency: bundle.price.currency
                }
              }
            ],
            characteristic: [
              { name: "volume", value: `${bundle.volume} ${bundle.volumeUnit}` },
              { name: "validPeriod", value: bundle.validPeriod.toString() },
              { name: "periodUnit", value: bundle.periodUnit },
              { name: "prePaidAllowed", value: bundle.prePaidAllowed.toString() },
              { name: "postPaidAllowed", value: bundle.postPaidAllowed.toString() }
            ]
          }))
        }
      ]
    };

    // Persist in DB if needed
    const poq = new ProductOfferingQualification(response);
    await poq.save();

    res.status(200).json(response);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
};
