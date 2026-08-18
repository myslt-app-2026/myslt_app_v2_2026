const getProfile = async (subscriberid) => {
  return {
    id: subscriberid,
    href: `/tmf-api/customerManagement/v4/customer/${subscriberid}`,
    name: "VAS Customer Profile",
    status: "active",
    customerType: "VAS",
    characteristic: [
      {
        name: "subscriberid",
        valueType: "string",
        value: subscriberid,
      },
      {
        name: "profileStatus",
        valueType: "string",
        value: "SUCCESS",
      },
    ],
    "@type": "Customer",
  };
};

module.exports = {
  getProfile,
};