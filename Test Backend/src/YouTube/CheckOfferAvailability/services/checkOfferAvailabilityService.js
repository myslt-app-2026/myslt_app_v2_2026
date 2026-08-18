const checkOfferAvailability = async (telephoneNo) => {
  if (!telephoneNo) {
    return {
      success: false,
      statusCode: 400,
      message: "telephoneNo is required",
    };
  }

  return {
    success: true,
    statusCode: 200,
    data: {
      telephoneNo,
      offerAvailable: true,
      offerName: "YouTube Buffer Offer",
    },
  };
};

module.exports = { checkOfferAvailability };