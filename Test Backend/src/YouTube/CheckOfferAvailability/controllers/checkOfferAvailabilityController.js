const {
  checkOfferAvailability,
} = require("../services/checkOfferAvailabilityService");

const checkOfferAvailabilityRequest = async (req, res) => {
  try {
    const { telephoneNo } = req.query;

    const result = await checkOfferAvailability(telephoneNo);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("CheckOfferAvailability Error:", error);

    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: "Internal Server Error",
    });
  }
};

module.exports = {
  checkOfferAvailabilityRequest,
};