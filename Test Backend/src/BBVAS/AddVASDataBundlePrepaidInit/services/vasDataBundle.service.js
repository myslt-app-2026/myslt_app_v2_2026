//src/services/vasDataBundle.service.js
const TMF622ProductOrder = require("../../../models/TMF622_ProductOrder");

exports.createVASBundle = async (data) => {
  const orderId = data.id || `VAS-${Date.now()}`;
  const vasBundle = new TMF622ProductOrder({
    id: orderId,
    href: `/tmf-api/productOrdering/v4/productOrder/${orderId}`,
    category: "VASDataBundlePrepaid",
    state: "acknowledged",
    relatedParty: [
      {
        id: data.customerId || "unknown",
        role: "customer",
        "@type": "RelatedParty",
      },
    ],
    productOrderItem: [
      {
        id: `${orderId}-1`,
        action: "add",
        state: "acknowledged",
        productOffering: {
          id: data.bundleId || data.bundleName || "VAS_DATA_BUNDLE",
          name: data.bundleName || "VAS Data Bundle",
          "@type": "ProductOfferingRef",
        },
        product: {
          isBundle: false,
          productCharacteristic: [
            { name: "dataVolume", value: data.dataVolume || "", "@type": "StringCharacteristic" },
            { name: "validity", value: data.validity || "", "@type": "StringCharacteristic" },
            { name: "price", value: data.price ?? null, "@type": "StringCharacteristic" },
          ],
          "@type": "Product",
        },
        "@type": "ProductOrderItem",
      },
    ],
    "@type": "ProductOrder",
    "@baseType": "ProductOrder",
  });
  return await vasBundle.save();
};

exports.getVASBundles = async () => {
  return await TMF622ProductOrder.find({ category: "VASDataBundlePrepaid" });
};
