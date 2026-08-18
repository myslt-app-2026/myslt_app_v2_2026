const { createSalesLead } = require("../services/newConSalesLeadService");

const newConSalesLeadRequest = async (req, res) => {
  try {
    const result = await createSalesLead(req.body);

    return res.status(result.statusCode).json(result);

  } catch (error) {
    console.error("NewConSalesLeadCreation error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { newConSalesLeadRequest };