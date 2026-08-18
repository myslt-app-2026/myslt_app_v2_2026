const Purchase = require("../../../models/TMF622_ProductOrder");
const { v4: uuidv4 } = require('uuid');

function getExternalIdentifier(order, type) {
  const ext = (order.externalId || []).find(
    (item) => item.externalIdentifierType === type
  );
  return ext ? ext.id : undefined;
}

function getCharacteristicValue(order, name) {
  const item = (order.productOrderItem || [])[0];
  const chars = item && item.product ? item.product.productCharacteristic || [] : [];
  const c = chars.find((entry) => entry.name === name);
  return c ? c.value : undefined;
}

function toLegacyResponse(order) {
  return {
    id: order.id,
    href: order.href,
    state: order.state,
    orderDate: order.creationDate || order.createdAt,
    completionDate: order.completionDate,
    relatedParty: order.relatedParty,
    purchaseID: getCharacteristicValue(order, "purchaseID"),
    payId: getExternalIdentifier(order, "payId"),
    pgResponseCode: getExternalIdentifier(order, "pgResponseCode"),
    data: getCharacteristicValue(order, "data") || {},
    channel: order.channel,
    note: order.note,
    "@type": order["@type"],
    "@baseType": order["@baseType"]
  };
}


exports.createPurchase = async (req, res) => {
  try {
    const subscriberId = req.headers['subscriber-id'] || req.headers['subscriberid'] || req.headers['x-subscriber-id'];
    
    if (!subscriberId) {
      return res.status(400).json({
        code: "400",
        reason: "Bad Request",
        message: "Subscriber ID is required in headers (subscriber-id, subscriberid, or x-subscriber-id)"
      });
    }

    const { purchaseID, payId, pgResponseCode, data } = req.body;
    if (!purchaseID) {
      return res.status(400).json({
        code: "400",
        reason: "Bad Request",
        message: "purchaseID is required"
      });
    }

    if (!payId) {
      return res.status(400).json({
        code: "400",
        reason: "Bad Request",
        message: "payId is required"
      });
    }

    if (!pgResponseCode) {
      return res.status(400).json({
        code: "400",
        reason: "Bad Request",
        message: "pgResponseCode is required"
      });
    }
    const orderId = `ORD-${uuidv4()}`;
    const orderHref = `/tmf-api/productOrderingManagement/v4/productOrder/${orderId}`;
    let orderState = "acknowledged";
    const notes = [];

    if (pgResponseCode === "SCP" || pgResponseCode === "SUCCESS") {
      orderState = "inProgress";
      notes.push({
        date: new Date(),
        author: "System",
        text: "Payment successful - Order in progress"
      });
    } else if (pgResponseCode === "FAILED" || pgResponseCode === "ERROR") {
      orderState = "failed";
      notes.push({
        date: new Date(),
        author: "System",
        text: `Payment failed with code: ${pgResponseCode}`
      });
    }
    const newPurchase = new Purchase({
      id: orderId,
      href: orderHref,
      relatedParty: [
        {
          id: subscriberId,
          role: "Customer",
          "@referredType": "Individual",
          "@type": "RelatedParty",
        },
      ],
      externalId: [
        {
          id: String(payId),
          owner: "payment",
          externalIdentifierType: "payId",
          "@type": "ExternalIdentifier",
        },
        {
          id: String(pgResponseCode),
          owner: "payment",
          externalIdentifierType: "pgResponseCode",
          "@type": "ExternalIdentifier",
        },
      ],
      state: orderState,
      creationDate: new Date(),
      channel: [
        {
          id: "OMNI-CHANNEL",
          name: "Omni Channel Portal",
          "@type": "RelatedChannel",
        },
      ],
      productOrderItem: [
        {
          id: `${orderId}-1`,
          action: "add",
          state: orderState,
          productOffering: {
            id: "DataGiftEnrollPrepaidConfirm",
            name: "DataGift Enroll Prepaid Confirm",
            "@type": "ProductOfferingRef",
          },
          product: {
            isBundle: false,
            productCharacteristic: [
              { name: "purchaseID", value: purchaseID, "@type": "StringCharacteristic" },
              { name: "data", value: data || {}, "@type": "StringCharacteristic" },
            ],
            "@type": "Product",
          },
          "@type": "ProductOrderItem",
        },
      ],
      note: notes,
      "@type": "ProductOrder",
      "@baseType": "ProductOrder"
    });

    await newPurchase.save();
    return res.status(201).json(toLegacyResponse(newPurchase));

  } catch (err) {
    console.error("Error creating purchase order:", err.message);
    return res.status(500).json({
      code: "500",
      reason: "Internal Server Error",
      message: err.message
    });
  }
};
exports.getPurchaseById = async (req, res) => {
  try {
    const { id } = req.params;

    const purchase = await Purchase.findOne({ id });

    if (!purchase) {
      return res.status(404).json({
        code: "404",
        reason: "Not Found",
        message: `Purchase order with id ${id} not found`
      });
    }

    return res.status(200).json(toLegacyResponse(purchase));

  } catch (err) {
    console.error("Error retrieving purchase order:", err.message);
    return res.status(500).json({
      code: "500",
      reason: "Internal Server Error",
      message: err.message
    });
  }
};

exports.getPurchasesBySubscriber = async (req, res) => {
  try {
    const subscriberId = req.headers['subscriber-id'] || req.headers['subscriberid'] || req.headers['x-subscriber-id'];
    
    if (!subscriberId) {
      return res.status(400).json({
        code: "400",
        reason: "Bad Request",
        message: "Subscriber ID is required in headers"
      });
    }

    const purchases = await Purchase.find({ "relatedParty.id": subscriberId }).sort({ creationDate: -1 });

    return res.status(200).json({
      total: purchases.length,
      orders: purchases.map(p => ({
        id: p.id,
        href: p.href,
        state: p.state,
        orderDate: p.creationDate || p.createdAt,
        completionDate: p.completionDate,
        purchaseID: getCharacteristicValue(p, "purchaseID"),
        payId: getExternalIdentifier(p, "payId"),
        pgResponseCode: getExternalIdentifier(p, "pgResponseCode"),
        "@type": p["@type"]
      }))
    });

  } catch (err) {
    console.error("Error retrieving purchase orders:", err.message);
    return res.status(500).json({
      code: "500",
      reason: "Internal Server Error",
      message: err.message
    });
  }
};
