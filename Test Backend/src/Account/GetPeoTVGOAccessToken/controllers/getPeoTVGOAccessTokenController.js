const peoTVGOAccessTokenService = require("../services/getPeoTVGOAccessTokenService");

const getPeoTVGOAccessToken = async (req, res) => {
  try {
    const subscriberId =
      req.headers.subscriberid || req.query.subscriberId;

    const channel = req.query.channel || "WEB";

    if (!subscriberId) {
      return res.status(400).json({
        error: "Bad Request",
        message: "subscriberid header or subscriberId query parameter is required",
      });
    }

    const response =
      await peoTVGOAccessTokenService.getPeoTVGOAccessToken({
        subscriberId,
        channel,
      });

    return res.status(200).json(response);
  } catch (error) {
    console.error("Get PeoTV GO Access Token Error:", error);

    return res.status(500).json({
      error: "Internal Server Error",
      message: "Internal server error",
    });
  }
};

module.exports = {
  getPeoTVGOAccessToken,
};