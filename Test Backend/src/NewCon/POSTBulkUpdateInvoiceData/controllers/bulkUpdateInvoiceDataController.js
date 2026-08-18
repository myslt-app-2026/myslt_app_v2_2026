const { bulkUpdateInvoiceData } = require("../services/bulkUpdateInvoiceDataService");

const bulkUpdateInvoiceDataRequest = async (req, res) => {
  try {
    const result = await bulkUpdateInvoiceData(req.body);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("BulkUpdateInvoiceData error:", error);
    return res.status(500).json({ success: false, message: "Internal Server Error" });
  }
};

module.exports = { bulkUpdateInvoiceDataRequest };