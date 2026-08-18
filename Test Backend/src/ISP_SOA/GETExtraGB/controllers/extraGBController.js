const {
  getExtraGB,
} = require("../services/extraGBService");

const extraGBRequest = async (req, res) => {
  try {
    const result = await getExtraGB(req.query);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("ExtraGB error:", error);

    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: "Internal Server Error",
    });
  }
};

module.exports = {
  extraGBRequest,
};