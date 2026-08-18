const DataGiftPrepaidOrder = require("../../../models/TMF622_ProductOrder");

const MOCK_VALID_OTP = "123456"; // TODO: replace with real SLT OTP gateway

async function verifyOTP(orderId, otp) {
  // TODO: Replace with real SLT OTP verification API call
  console.log(`[Confirm] Verifying OTP for order: ${orderId}`);
  return otp === MOCK_VALID_OTP;
}

async function confirmPrepaidOrder(orderId, otp) {
  const order = await DataGiftPrepaidOrder.findOne({ id: orderId });

  if (!order) {
    const err = new Error(`ProductOrder not found: ${orderId}`);
    err.statusCode = 404;
    throw err;
  }

  if (order.state !== "acknowledged") {
    const err = new Error(
      `Order ${orderId} cannot be confirmed — current state: ${order.state}`
    );
    err.statusCode = 422;
    throw err;
  }

  const otpValid       = await verifyOTP(orderId, otp);
  order.state          = otpValid ? "completed" : "failed";
  order.completionDate = new Date();

  order.note.push({
    author: "System",
    date:   new Date(),
    text:   otpValid
      ? "OTP verified successfully. Data gift activated."
      : "OTP verification failed. Order cancelled.",
  });

  const updatedOrder = await order.save();
  return { order: updatedOrder, otpValid };
}

module.exports = { confirmPrepaidOrder };