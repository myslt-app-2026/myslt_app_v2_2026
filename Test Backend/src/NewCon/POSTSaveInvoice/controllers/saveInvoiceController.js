const { saveInvoice } = require("../services/saveInvoiceService");

const saveInvoiceRequest = async (req, res) => {
  try {
    const result = await saveInvoice(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("SaveInvoice error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { saveInvoiceRequest };