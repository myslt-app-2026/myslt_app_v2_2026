const { updatePaymentLogs } = require("../services/updatePaymentLogsService");

const updatePaymentLogsRequest = async (req, res) => {
  try {

    const result = await updatePaymentLogs(req.body);

    return res.status(result.statusCode).json(result);

  } catch (error) {

    console.error("UpdatePaymentLogs error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { updatePaymentLogsRequest };