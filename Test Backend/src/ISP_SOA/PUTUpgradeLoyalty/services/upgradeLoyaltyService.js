const upgradeLoyalty = async (payload) => {
  const {
    subscriberId,
    loyaltyTier,
    loyaltyLevel,
    claimType = "LOYALTY_UPGRADE",
    channel = "WEB",
    relatedParty = [],
  } = payload;

  const selectedLoyaltyTier = loyaltyTier || loyaltyLevel;

  return {
    id: `LOY-${Date.now()}`,
    href: `/tmf-api/customerManagement/v4/customer/loyalty/claim`,
    name: "Broadband Loyalty Upgrade",
    status: "active",
    statusReason: "Loyalty upgrade claim completed successfully",
    customerType: "Broadband",
    characteristic: [
      {
        name: "subscriberId",
        valueType: "string",
        value: subscriberId,
      },
      {
        name: "loyaltyTier",
        valueType: "string",
        value: selectedLoyaltyTier,
      },
      {
        name: "claimType",
        valueType: "string",
        value: claimType,
      },
      {
        name: "channel",
        valueType: "string",
        value: channel,
      },
      {
        name: "claimStatus",
        valueType: "string",
        value: "SUCCESS",
      },
    ],
    relatedParty,
    "@type": "Customer",
  };
};

module.exports = {
  upgradeLoyalty,
};