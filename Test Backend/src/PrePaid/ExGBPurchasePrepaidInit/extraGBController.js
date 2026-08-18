const ProductOrder = require("../../models/TMF622_ProductOrder");

/**
 * TMF622 – POST /productOrder
 * Maps to: ExGBPurchasePrepaidInit
 */
exports.createProductOrder = async (req, res) => {
  try {
    const { orderItem, relatedParty, channel } = req.body;

    if (!orderItem || !Array.isArray(orderItem) || orderItem.length === 0) {
      return res.status(400).json({
        code: "BAD_REQUEST",
        message: "orderItem is required"
      });
    }

    if (!orderItem[0].productOffering?.id) {
      return res.status(400).json({
        code: "BAD_REQUEST",
        message: "productOffering.id is required"
      });
    }

    if (!relatedParty || relatedParty.length === 0) {
      return res.status(400).json({
        code: "BAD_REQUEST",
        message: "relatedParty is required"
      });
    }

    const orderId = `EXGB-${Date.now()}`;
    const normalizedOrderItems = orderItem.map((item, index) => ({
      id: item.id || `${orderId}-${index + 1}`,
      action: item.action || "add",
      quantity: item.quantity || 1,
      state: "acknowledged",
      productOffering: item.productOffering,
      product: item.product,
      "@type": "ProductOrderItem",
    }));

    const order = await ProductOrder.create({
      id: orderId,
      href: `/tmf-api/productOrder/v5/productOrder/${orderId}`,
      state: "acknowledged",
      productOrderItem: normalizedOrderItems,
      relatedParty,
      channel,
      category: "ExtraGB",
      "@type": "ProductOrder",
      "@baseType": "ProductOrder",
    });

    res.status(201).json(order);

  } catch (err) {
    res.status(500).json({
      code: "INTERNAL_ERROR",
      message: err.message
    });
  }
};


/**
 * TMF622 – PATCH /productOrder/{id}
 * Maps to: ExGBPurchasePrepaidConfirm
 */
exports.updateProductOrder = async (req, res) => {
  try {
    const { id } = req.params;
    const { pgResponseCode, payId } = req.body;

    let order = await ProductOrder.findOne({ id });
    if (!order) {
      order = await ProductOrder.findById(id);
    }

    if (!order) {
      return res.status(404).json({
        code: "NOT_FOUND",
        message: "ProductOrder not found"
      });
    }

    const paymentSuccess = pgResponseCode === "1";

    order.state = paymentSuccess ? "completed" : "failed";
    if (order.productOrderItem && order.productOrderItem.length > 0) {
      order.productOrderItem[0].state = order.state;
    }

    order.externalId = [
      { id: String(payId || ""), owner: "payment", externalIdentifierType: "payId" },
      { id: String(pgResponseCode || ""), owner: "payment", externalIdentifierType: "pgResponseCode" },
    ];

    await order.save();

    res.status(200).json(order);

  } catch (err) {
    res.status(500).json({
      code: "INTERNAL_ERROR",
      message: err.message
    });
  }
};
