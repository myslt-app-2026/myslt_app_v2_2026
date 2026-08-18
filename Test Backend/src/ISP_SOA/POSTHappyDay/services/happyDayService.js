const enrollHappyDay = async (payload) => {
  const {
    subscriberId,
    happyDay,
    happyDayDate,
    selectedDate,
    channel = "WEB",
    relatedParty = [],
  } = payload;

  const selectedHappyDay = happyDay || happyDayDate || selectedDate;

  return {
    id: `HD-${Date.now()}`,
    href: `/tmf-api/productOrderingManagement/v4/productOrder/happyDay`,
    category: "HappyDayEnrollment",
    description: "Enroll Happy Day offer for broadband subscriber",
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
          id: subscriberId,
          name: "Happy Day Offer",
          productCharacteristic: [
            {
              name: "subscriberId",
              valueType: "string",
              value: subscriberId,
            },
            {
              name: "happyDay",
              valueType: "string",
              value: selectedHappyDay,
            },
            {
              name: "enrollmentStatus",
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
  enrollHappyDay,
};