const { getInvoiceData } = require("../services/getInvoiceDataService");

const getInvoiceDataRequest = async (req, res) => {
  try {
    const result = await getInvoiceData(req.query);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("GetInvoiceData error:", error);
    return res.status(500).json({ success: false, message: "Internal Server Error" });
  }
};

module.exports = { getInvoiceDataRequest };