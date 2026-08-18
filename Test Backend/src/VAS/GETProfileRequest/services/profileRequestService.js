const Customer = require("../../../models/TMF629_Customer");

const getProfileRequest = async (query) => {

  const { subscriberID } = query;

  if (!subscriberID) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID is required"
    };
  }

  const customer = await Customer.findOne({ id: subscriberID });

  if (!customer) {
    return {
      success: false,
      statusCode: 404,
      message: `No profile found for subscriberID: ${subscriberID}`
    };
  }

  return {
    success: true,
    statusCode: 200,
    data: {
      id: customer.id,
      href: customer.href,
      status: customer.status,
      engagedParty: customer.engagedParty,
      contactMedium: customer.contactMedium,
      account: customer.account,
      "@type": "Customer"
    }
  };
};

module.exports = { getProfileRequest };