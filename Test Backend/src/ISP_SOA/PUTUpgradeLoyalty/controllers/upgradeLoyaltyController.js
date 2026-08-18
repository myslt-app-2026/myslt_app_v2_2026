const upgradeLoyaltyService = require("../services/upgradeLoyaltyService");

const upgradeLoyalty = async (req, res) => {
  try {
    const { subscriberId, loyaltyTier, loyaltyLevel } = req.body;

    const selectedLoyaltyTier = loyaltyTier || loyaltyLevel;

    if (!subscriberId) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberId is required",
      });
    }

    if (!selectedLoyaltyTier) {
      return res.status(400).json({
        error: "Bad Request",
        message: "loyaltyTier is required",
      });
    }

    const response = await upgradeLoyaltyService.upgradeLoyalty(req.body);

    return res.status(200).json(response);
  } catch (error) {
    console.error("Upgrade Loyalty error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  upgradeLoyalty,
};