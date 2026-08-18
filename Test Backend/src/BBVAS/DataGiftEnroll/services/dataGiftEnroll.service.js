const { v4: uuidv4 } = require("uuid");
const ProductOrder = require("../../../models/TMF622_ProductOrder");

async function createDataGift(data) {
  const order = new ProductOrder({
    id:          data.id || uuidv4(),
    description: "Data Gift Enrollment",
    category:    "DataGift",
    state:       "acknowledged",
    relatedParty: [
      {
        id:   data.senderId,
        role: "sender",
        "@type": "RelatedParty",
      },
      {
        id:   data.receiverId,
        role: "receiver",
        "@type": "RelatedParty",
      },
    ],
    productOrderItem: [
      {
        id:     uuidv4(),
        action: "add",
        productOffering: {
          name:    data.bundleName,
          "@type": "ProductOfferingRef",
        },
        product: {
          productCharacteristic: [
            { name: "dataVolume", value: data.dataVolume },
            { name: "validity",   value: data.validity },
          ],
        },
        "@type": "ProductOrderItem",
      },
    ],
    "@type": "ProductOrder",
  });

  return await order.save();
}

module.exports = { createDataGift };