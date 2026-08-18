const { upgradeLoyalty } = require("../services/upgradeLoyaltyService");

const upgradeLoyaltyRequest = async (req, res) => {

  try {

    const result = await upgradeLoyalty(req.body);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error(error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { upgradeLoyaltyRequest };