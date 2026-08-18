const ProductOrder = require("../../../models/TMF622_ProductOrder");

const createUnsubscriptionOrder = async (body) => {
  const { subscriberID, productId } = body;

  if (!subscriberID || !productId) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberID and productId are required",
    };
  }

  const order = await ProductOrder.create({
    id: "ORD-" + Date.now(),
    category: "VASBundleUnsubscription",
    description: "VAS Bundle Unsubscription Request",
    state: "acknowledged",

    relatedParty: [
      {
        id: subscriberID,
        name: subscriberID,
        role: "Customer",
        "@referredType": "Individual",
        "@type": "RelatedParty"
      }
    ],

    productOrderItem: [
      {
        id: "1",
        action: "delete",
        state: "acknowledged",
        productOffering: {
          id: productId,
          name: productId,
          "@referredType": "ProductOffering",
          "@type": "ProductOfferingRef"
        },
        "@type": "ProductOrderItem"
      }
    ],

    "@type": "ProductOrder",
    "@baseType": "ProductOrder"
  });

  return {
    success: true,
    statusCode: 201,
    data: order,
  };
};

module.exports = { createUnsubscriptionOrder };