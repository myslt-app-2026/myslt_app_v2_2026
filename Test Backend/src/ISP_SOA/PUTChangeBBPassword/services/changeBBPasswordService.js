const changeBBPassword = async (payload) => {
  const {
    subscriberId,
    broadbandUsername,
    username,
    channel = "WEB",
    relatedParty = [],
  } = payload;

  const selectedUsername = broadbandUsername || username;

  return {
    id: `BBPWD-${Date.now()}`,
    href: `/tmf-api/customerManagement/v4/customer/profile/broadbandPassword`,
    name: "Broadband Password Change",
    status: "active",
    statusReason: "Broadband password changed successfully",
    customerType: "Broadband",
    characteristic: [
      {
        name: "subscriberId",
        valueType: "string",
        value: subscriberId,
      },
      {
        name: "broadbandUsername",
        valueType: "string",
        value: selectedUsername,
      },
      {
        name: "channel",
        valueType: "string",
        value: channel,
      },
      {
        name: "passwordChangeStatus",
        valueType: "string",
        value: "SUCCESS",
      },
      {
        name: "passwordLastChangedDate",
        valueType: "string",
        value: new Date().toISOString(),
      },
    ],
    relatedParty,
    "@type": "Customer",
  };
};

module.exports = {
  changeBBPassword,
};