const Application = require("../../../models/TMF622_ProductOrder");

const applicationGenerator = async (body = {}) => {
  const { accountNo, customerName, createdBy } = body;

  if (!accountNo || !customerName) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo and customerName are required",
    };
  }

  const applicationId = "APP-" + Date.now();
  const orderId = "ORD-" + Date.now();

  const application = await Application.create({
    id: orderId,
    href: `/tmf-api/productOrdering/v4/ApplicationGenerator/${orderId}`,
    category: "ApplicationGenerator",
    description: "New connection application generated",
    state: "acknowledged",
    notificationContact: createdBy || customerName,

    relatedParty: [
      {
        id: accountNo,
        name: customerName,
        role: "Customer",
        "@referredType": "Individual",
        "@type": "RelatedParty",
      },
    ],

    productOrderItem: [
      {
        id: "1",
        quantity: 1,
        action: "add",
        state: "acknowledged",
        productOffering: {
          id: applicationId,
          name: "New Connection Application",
          "@referredType": "ProductOffering",
          "@type": "ProductOfferingRef",
        },
        "@type": "ProductOrderItem",
      },
    ],

    "@type": "ProductOrder",
    "@baseType": "ProductOrder",
  });

  return {
    success: true,
    statusCode: 201,
    message: "Application generated successfully",
    applicationId,
    data: application,
  };
};

module.exports = { applicationGenerator };