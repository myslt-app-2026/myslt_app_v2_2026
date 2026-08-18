const { v4: uuidv4 } = require("uuid");
const ProductOrder = require("../../../models/TMF622_ProductOrder");

/**
 * Builds the TMF622 ProductOrder document for ExGBPurchasePrepaidInit.
 * @param {Object} body - Request body
 */
function buildOrderDocument(body) {
  const orderId = uuidv4();
  const itemId  = uuidv4();

  return {
    id:          orderId,
    href:        `/tmf-api/productOrder/v5/productOrder/${orderId}`,
    description: body.description || "Extra GB Purchase - Prepaid Init",
    category:    "ExtraGB",
    priority:    body.priority || "4",
    state:       "acknowledged",

    requestedStartDate:      body.requestedStartDate
      ? new Date(body.requestedStartDate)
      : new Date(),
    requestedCompletionDate: body.requestedCompletionDate
      ? new Date(body.requestedCompletionDate)
      : null,

    channel: [
      {
        id:   body.channel?.id   || "MySLT",
        name: body.channel?.name || "MySLT App",
      },
    ],

    relatedParty: [
      {
        id:              body.subscriberId,
        role:            "Customer",
        name:            body.subscriberName || "",
        "@referredType": "Customer",
      },
    ],

    productOrderItem: [
      {
        id:       itemId,
        action:   "add",
        quantity: 1,
        productOffering: {
          id:              body.packageId,
          name:            body.packageName || "",
          "@referredType": "ProductOffering",
        },
        product: {
          productCharacteristic: [
            {
              name:      "dataVolume",
              value:     body.dataVolume || "",
              valueType: "String",
            },
            {
              name:      "validity",
              value:     body.validity || "",
              valueType: "String",
            },
          ],
        },
      },
    ],

    note: [
      {
        id:     uuidv4(),
        author: "System",
        date:   new Date(),
        text:   "Extra GB purchase initiated — awaiting payment confirmation.",
      },
    ],

    orderDate: new Date(),
    "@type":   "ProductOrder",
  };
}

/**
 * Creates a new ProductOrder for ExGBPurchasePrepaidInit.
 * @param {Object} body - Validated request body
 * @returns {Promise<Object>} Saved Mongoose document
 */
async function createExGBPrepaidInitOrder(body) {
  const orderDoc   = buildOrderDocument(body);
  const order      = new ProductOrder(orderDoc);
  const savedOrder = await order.save();
  return savedOrder;
}

module.exports = { createExGBPrepaidInitOrder };