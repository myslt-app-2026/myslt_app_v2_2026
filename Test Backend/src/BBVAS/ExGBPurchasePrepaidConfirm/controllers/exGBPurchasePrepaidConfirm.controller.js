const confirmService = require("../services/exGBPurchasePrepaidConfirm.service");

/**
 * GET /ExGBPurchasePrepaidConfirm
 * TMF622 – Retrieves a ProductOrder and confirms payment result.
 *
 * Query params:
 *   orderId        (required) – the UUID returned from ExGBPurchasePrepaidInit
 *   pgResponseCode (required) – payment gateway code ("1" = success)
 *   payId          (required) – payment gateway transaction ID
 */
exports.confirmExGBPrepaid = async (req, res) => {
  try {
    const { orderId, pgResponseCode, payId } = req.query;

    // ── 1. Validate required query params ─────────────────────────────────
    if (!orderId || !pgResponseCode || !payId) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "Missing required query parameter(s): orderId, pgResponseCode, payId",
        status:  "400",
        "@type": "Error",
      });
    }

    // ── 2. Confirm order via service ──────────────────────────────────────
    const { order, paymentSuccess } = await confirmService.confirmExGBPrepaidOrder(
      orderId,
      pgResponseCode,
      payId
    );

    const httpStatus = paymentSuccess ? 200 : 422;

    // ── 3. Return TMF622-shaped response ──────────────────────────────────
    return res.status(httpStatus).json({
      id:              order.id,
      href:            order.href,
      description:     order.description,
      category:        order.category,
      state:           order.state,
      orderDate:       order.orderDate,
      completionDate:  order.completionDate,
      externalId:      order.externalId,
      channel:         order.channel,
      relatedParty:    order.relatedParty,
      productOrderItem:order.productOrderItem,
      note:            order.note,
      "@type":         order["@type"],
      message: paymentSuccess
        ? "Extra GB purchase confirmed successfully."
        : "Payment failed. Please retry.",
    });

  } catch (error) {
    console.error("[ExGBPurchasePrepaidConfirm] Error:", error);
    const status = error.statusCode || 500;
    return res.status(status).json({
      code:    String(status),
      reason:  status === 404 ? "Not Found"
             : status === 422 ? "Unprocessable Entity"
             :                  "Internal Server Error",
      message: error.message,
      status:  String(status),
      "@type": "Error",
    });
  }
};