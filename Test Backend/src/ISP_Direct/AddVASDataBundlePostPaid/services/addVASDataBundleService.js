const addVASDataBundle = async (payload, subscriberid) => {
  const {
    packageId,
    bundleId,
    offerCode,
    channel = "WEB",
    relatedParty = [],
  } = payload;

  return {
    id: `VAS-ADD-${Date.now()}`,
    href: `/tmf-api/productOrderingManagement/v4/productOrder/vasDataBundle/enroll`,
    category: "VASDataBundleEnrollment",
    description: "Add VAS data bundle for ISP Direct postpaid subscriber",
    state: "completed",
    orderDate: new Date().toISOString(),
    channel: [
      {
        id: channel,
        name: channel,
        "@type": "ChannelRef",
      },
    ],
    relatedParty,
    productOrderItem: [
      {
        id: "1",
        action: "add",
        state: "completed",
        product: {
          id: subscriberid,
          name: "VAS Data Bundle",
          productCharacteristic: [
            {
              name: "subscriberid",
              valueType: "string",
              value: subscriberid,
            },
            {
              name: "packageId",
              valueType: "string",
              value: packageId || null,
            },
            {
              name: "bundleId",
              valueType: "string",
              value: bundleId || null,
            },
            {
              name: "offerCode",
              valueType: "string",
              value: offerCode || null,
            },
            {
              name: "activationStatus",
              valueType: "string",
              value: "SUCCESS",
            },
          ],
          "@type": "Product",
        },
        "@type": "ProductOrderItem",
      },
    ],
    "@type": "ProductOrder",
  };
};

module.exports = {
  addVASDataBundle,
};