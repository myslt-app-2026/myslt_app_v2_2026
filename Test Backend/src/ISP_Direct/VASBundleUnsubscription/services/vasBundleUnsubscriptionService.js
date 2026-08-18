const unsubscribeVASBundle = async (payload, subscriberid) => {
  const {
    packageId,
    bundleId,
    offerCode,
    reason = "Customer requested unsubscription",
    channel = "WEB",
    relatedParty = [],
  } = payload;

  return {
    id: `VAS-UNSUB-${Date.now()}`,
    href: `/tmf-api/productOrderingManagement/v4/productOrder/vasDataBundle/unsubscribe`,
    category: "VASDataBundleUnsubscription",
    description: "Unsubscribe VAS data bundle for ISP Direct subscriber",
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
        action: "delete",
        state: "completed",
        product: {
          id: subscriberid,
          name: "VAS Data Bundle Unsubscription",
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
              name: "reason",
              valueType: "string",
              value: reason,
            },
            {
              name: "unsubscriptionStatus",
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
  unsubscribeVASBundle,
};