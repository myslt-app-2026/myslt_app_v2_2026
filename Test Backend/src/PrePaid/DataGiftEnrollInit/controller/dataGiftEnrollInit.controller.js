const TMF622ProductOrder = require("../../../models/TMF622_ProductOrder");

exports.createDataGiftEnrollInit = async (req, res) => {
  try {
    const { packageId, reciever, channel, url } = req.body;
    const subscriberId = req.headers["subscriber-id"] || req.headers["subscriberid"];

    if (!subscriberId) {
      return res.status(400).json({ 
        code: "400", 
        reason: "Missing subscriber ID in header" 
      });
    }

    if (!packageId || !reciever || !channel || !url) {
      return res.status(400).json({ 
        code: "400", 
        reason: "Missing required fields: packageId, reciever, channel, or url" 
      });
    }

    const orderId = `DGEI-${Date.now()}`;
    const orderItemId = `${orderId}-1`;
    const newEnrollment = new TMF622ProductOrder({
      id: orderId,
      href: `/tmf-api/productOrdering/v4/productOrder/${orderId}`,
      category: "DataGift",
      state: "acknowledged",
      relatedParty: [
        {
          id: subscriberId,
          role: "subscriber",
          "@type": "RelatedParty",
        },
      ],
      channel: [
        {
          name: channel,
          "@type": "RelatedChannel",
        },
      ],
      productOrderItem: [
        {
          id: orderItemId,
          action: "add",
          productOffering: {
            id: packageId,
            name: packageId,
            "@type": "ProductOfferingRef",
          },
          product: {
            isBundle: false,
            productCharacteristic: [
              { name: "receiver", value: reciever, "@type": "StringCharacteristic" },
              { name: "callbackUrl", value: url, "@type": "StringCharacteristic" },
            ],
            "@type": "Product",
          },
          "@type": "ProductOrderItem",
        },
      ],
      "@type": "ProductOrder",
      "@baseType": "ProductOrder",
    });

    await newEnrollment.save();

    return res.status(201).json({
      code: "201",
      message: "DataGift Enrollment Initialization created successfully",
      data: newEnrollment
    });
  } catch (err) {
    console.error("Error creating DataGift Enrollment Init:", err.message);
    return res.status(500).json({ 
      code: "500", 
      reason: "Internal Server Error", 
      message: err.message 
    });
  }
};

