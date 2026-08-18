const ProductOrder = require("../../../models/TMF622_ProductOrder");

const upgradeLoyalty = async (body) => {

  const { subscriberID, productOfferingId } = body;

  if (!subscriberID || !productOfferingId) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID and productOfferingId are required"
    };
  }

  const order = new ProductOrder({
    id: "ORD_" + Date.now(),
    category: "LoyaltyUpgrade",
    state: "acknowledged",
    relatedParty: [
      {
        id: subscriberID,
        role: "Customer"
      }
    ],
    productOrderItem: [
      {
        id: "1",
        action: "add",
        productOffering: {
          id: productOfferingId,
          name: "Loyalty Upgrade"
        }
      }
    ],
    "@type": "ProductOrder"
  });

  await order.save();

  return {
    success: true,
    statusCode: 200,
    message: "Loyalty upgrade order created",
    data: order
  };
};

module.exports = { upgradeLoyalty };