const { updateSaveInvoice } = require("../services/updateSaveInvoiceService");

const updateSaveInvoiceRequest = async (req, res) => {
  try {
    const result = await updateSaveInvoice(req.body);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("UpdateSaveInvoice error:", error);
    return res.status(500).json({ success: false, message: "Internal Server Error" });
  }
};

module.exports = { updateSaveInvoiceRequest };