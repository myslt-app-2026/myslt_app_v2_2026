const {
  getProtocolReport
} = require("../services/protocolReportService");

const protocolReportRequest = async (req, res) => {
        
  try {

    const result = await getProtocolReport(req.query);

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

module.exports = {
  protocolReportRequest
};