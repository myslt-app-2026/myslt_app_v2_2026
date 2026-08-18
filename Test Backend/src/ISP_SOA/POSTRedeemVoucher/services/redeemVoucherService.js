const redeemVoucher = async (payload) => {
  const {
    subscriberId,
    voucherCode,
    channel = "WEB",
    relatedParty = [],
  } = payload;

  return {
    id: `RV-${Date.now()}`,
    href: `/tmf-api/productOrderingManagement/v4/productOrder/redeemVoucher`,
    category: "RedeemVoucher",
    description: "Redeem voucher for broadband subscriber",
    state: "completed",
    orderDate: new Date().toISOString(),
    externalId: voucherCode,
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
          id: subscriberId,
          name: "Broadband Voucher Redemption",
          productCharacteristic: [
            {
              name: "subscriberId",
              valueType: "string",
              value: subscriberId,
            },
            {
              name: "voucherCode",
              valueType: "string",
              value: voucherCode,
            },
            {
              name: "redemptionStatus",
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
  redeemVoucher,
};