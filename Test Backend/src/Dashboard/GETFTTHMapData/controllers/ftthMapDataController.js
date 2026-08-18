const { getFTTHMapData } = require("../services/ftthMapDataService");

const getFTTHMapDataRequest = async (req, res) => {
  try {
    const result = await getFTTHMapData(req.query);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("GetFTTHMapData Error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { getFTTHMapDataRequest };