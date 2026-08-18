const { getPaymentLogs } = require("../services/getPaymentLogsService");

const getPaymentLogsRequest = async (req, res) => {
  try {

    const result = await getPaymentLogs(req.query);

    return res.status(result.statusCode).json(result);

  } catch (error) {

    console.error("GetPaymentLogs error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { getPaymentLogsRequest };