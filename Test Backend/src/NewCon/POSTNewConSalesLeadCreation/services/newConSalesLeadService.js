const ProductOrder = require("../../../models/TMF622_ProductOrder");

const createSalesLead = async (body = {}) => {
  const {
    customerName,
    tpNo,
    email,
    address,
    requestedPackage
  } = body;

  if (!customerName || !tpNo) {
    return {
      success: false,
      statusCode: 400,
      message: "customerName and tpNo are required"
    };
  }

  const leadId = "LEAD-" + Date.now();

  const lead = await ProductOrder.create({
    id: leadId,
    category: "NewConSalesLeadCreation",
    description: "New connection sales lead created",
    state: "acknowledged",

    relatedParty: [
      {
        id: tpNo,
        name: customerName,
        role: "Customer"
      }
    ],

    note: [
      {
        text: requestedPackage || "General Inquiry"
      }
    ],

    "@type": "ProductOrder"
  });

  return {
    success: true,
    statusCode: 201,
    message: "Sales lead created successfully",
    data: lead
  };
};

module.exports = { createSalesLead };