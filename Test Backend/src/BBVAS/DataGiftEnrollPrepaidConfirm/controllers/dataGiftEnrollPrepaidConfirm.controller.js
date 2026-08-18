const dataGiftConfirmService = require("../services/dataGiftEnrollPrepaidConfirm.service");

exports.confirmDataGiftEnrollPrepaid = async (req, res) => {
  try {
    const { orderId, otp } = req.body;

    if (!orderId || !otp) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "Both 'orderId' and 'otp' are required.",
        status:  "400",
        "@type": "Error",
      });
    }

    const { order, otpValid } = await dataGiftConfirmService.confirmPrepaidOrder(
      orderId,
      otp
    );

    const httpStatus = otpValid ? 200 : 422;

    return res.status(httpStatus).json({
      id:               order.id,
      href:             order.href,
      externalId:       order.externalId,
      description:      order.description,
      category:         order.category,
      priority:         order.priority,
      state:            order.state,
      orderDate:        order.orderDate,
      completionDate:   order.completionDate,
      channel:          order.channel,
      relatedParty:     order.relatedParty,
      productOrderItem: order.productOrderItem,
      note:             order.note,
      "@type":          order["@type"],
      message: otpValid
        ? "Data gift successfully activated."
        : "OTP verification failed. Please retry or request a new OTP.",
    });

  } catch (error) {
    console.error("[DataGiftEnrollPrepaidConfirm] Error:", error);
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