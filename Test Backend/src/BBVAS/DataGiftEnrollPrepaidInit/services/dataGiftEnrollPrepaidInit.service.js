const { v4: uuidv4 } = require("uuid");
const DataGiftPrepaidOrder = require("../../../models/TMF622_ProductOrder");

function buildOrderDocument(body) {
  const orderId = uuidv4();
  const itemId  = uuidv4();

  return {
    id:   orderId,
    href: `/tmf-api/productOrdering/v4/productOrder/${orderId}`,
    externalId:  body.externalId  || null,
    description: body.description || "Data Gift Prepaid Enrolment - Init",
    category:    "DataGift",
    priority:    body.priority || "4",
    requestedStartDate: body.requestedStartDate
      ? new Date(body.requestedStartDate)
      : new Date(),
    requestedCompletionDate: body.requestedCompletionDate
      ? new Date(body.requestedCompletionDate)
      : null,
    state: "acknowledged",
    channel: {
      id:   body.channel?.id   || "MySLT",
      name: body.channel?.name || "MySLT App",
    },
    relatedParty: [
      {
        id:              body.senderId,
        role:            "sender",
        name:            body.senderName || "",
        "@referredType": "Customer",
      },
      {
        id:              body.receiverId,
        role:            "receiver",
        name:            body.receiverName || "",
        "@referredType": "Customer",
      },
    ],
    productOrderItem: [
      {
        id:     itemId,
        action: "add",
        productOffering: {
          id:              body.bundleId || uuidv4(),
          name:            body.bundleName,
          "@referredType": "ProductOffering",
        },
        product: {
          productCharacteristic: [
            { name: "dataVolume", value: body.dataVolume, valueType: "String" },
            { name: "validity",   value: body.validity,   valueType: "String" },
          ],
        },
        quantity: 1,
      },
    ],
    note: [
      {
        id:     uuidv4(),
        author: "System",
        date:   new Date(),
        text:   "OTP dispatched — awaiting confirmation.",
      },
    ],
    orderDate: new Date(),
    "@type":   "ProductOrder",
  };
}

async function dispatchOTP(senderId) {
  // TODO: Replace with real SLT OTP gateway call
  console.log(`[Init] OTP dispatched to sender: ${senderId}`);
}

async function createPrepaidInitOrder(body) {
  const orderDoc   = buildOrderDocument(body);
  const order      = new DataGiftPrepaidOrder(orderDoc);
  const savedOrder = await order.save();
  await dispatchOTP(body.senderId);
  return savedOrder;
}

module.exports = { createPrepaidInitOrder };