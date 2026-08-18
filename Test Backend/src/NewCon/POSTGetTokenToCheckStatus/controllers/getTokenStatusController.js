const { getTokenStatus } = require("../services/getTokenStatusService");

const getTokenStatusRequest = async (req, res) => {
  try {

    const result = await getTokenStatus(req.body);

    return res.status(result.statusCode).json(result);

  } catch (error) {

    console.error("GetTokenToCheckStatus error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { getTokenStatusRequest };