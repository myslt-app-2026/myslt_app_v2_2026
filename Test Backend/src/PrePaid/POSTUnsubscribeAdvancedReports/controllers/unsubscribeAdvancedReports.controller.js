const ProductOrder = require("../../../models/TMF622_ProductOrder");

/**
 * POST - Unsubscribe Advanced Reports
 */
exports.unsubscribeAdvancedReports = async (req, res) => {
  try {
    const body = req.body || {};
    const { activatedBy } = body;
    const subscriberId =
      req.headers["subscriber-id"] ||
      req.headers["subscriberid"] ||
      req.headers["x-subscriber-id"];

    if (!activatedBy) {
      return res.status(400).json({
        success: false,
        message: "activatedBy is required",
        debug: {
          receivedBody: req.body,
          contentType: req.headers["content-type"]
        }
      });
    }

    const orderId = `UNSUB-${Date.now()}`;
    const savedRecord = await ProductOrder.create({
      id: orderId,
      href: `/tmf-api/productOrdering/v4/productOrder/${orderId}`,
      category: "AdvancedReports",
      state: "completed",
      relatedParty: [
        {
          id: subscriberId || "unknown",
          role: "customer",
          "@type": "RelatedParty",
        },
        {
          name: activatedBy,
          role: "initiator",
          "@type": "RelatedParty",
        },
      ],
      productOrderItem: [
        {
          id: `${orderId}-1`,
          action: "delete",
          state: "completed",
          productOffering: {
            id: "AdvancedReports",
            name: "Advanced Reports",
            "@type": "ProductOfferingRef",
          },
          "@type": "ProductOrderItem",
        },
      ],
      note: [
        {
          author: activatedBy,
          date: new Date(),
          text: "Advanced Reports unsubscribed successfully",
          "@type": "Note",
        },
      ],
      "@type": "ProductOrder",
      "@baseType": "ProductOrder",
    });

    return res.status(201).json({
      success: true,
      message: "Advanced Reports unsubscribed successfully",
      data: savedRecord
    });
  } catch (error) {
    console.error("Unsubscribe Advanced Reports Error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error"
    });
  }
};
