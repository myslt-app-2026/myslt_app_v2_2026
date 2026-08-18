const {
  getFTTHSpecificDataFilter,
} = require("../services/ftthSpecificDataFilterService");

const getFTTHSpecificDataFilterRequest = async (req, res) => {
  try {
    const result = await getFTTHSpecificDataFilter(req.query);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("GetFTTHSpecificDataFilter Error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { getFTTHSpecificDataFilterRequest };