const ProductOrder = require("../../../models/TMF622_ProductOrder");

/**
 * Retrieves a ProductOrder by its custom `id` field (UUID, not Mongo _id).
 * Used by ExGBPurchasePrepaidConfirm (GET) to check the payment result.
 *
 * @param {string} orderId  - The UUID generated during ExGBPurchasePrepaidInit
 * @param {string} pgResponseCode - Payment gateway response code ("1" = success)
 * @param {string} payId    - Payment gateway transaction ID
 * @returns {Promise<Object>} Updated Mongoose document
 */
async function confirmExGBPrepaidOrder(orderId, pgResponseCode, payId) {
  // ── 1. Find the order ───────────────────────────────────────────────────
  const order = await ProductOrder.findOne({ id: orderId });

  if (!order) {
    const err = new Error(`ProductOrder not found: ${orderId}`);
    err.statusCode = 404;
    throw err;
  }

  // ── 2. Guard against re-confirmation ───────────────────────────────────
  if (order.state !== "acknowledged") {
    const err = new Error(
      `Order ${orderId} cannot be confirmed — current state: ${order.state}`
    );
    err.statusCode = 422;
    throw err;
  }

  // ── 3. Determine success or failure from payment gateway ────────────────
  const paymentSuccess = pgResponseCode === "1";
  order.state          = paymentSuccess ? "completed" : "failed";
  order.completionDate = new Date();

  // ── 4. Attach payment reference to externalId ───────────────────────────
  order.externalId.push({
    id:                     payId,
    owner:                  "PaymentGateway",
    externalIdentifierType: "PAYMENT_ID",
  });

  // ── 5. Add an audit note ─────────────────────────────────────────────────
  order.note.push({
    author: "System",
    date:   new Date(),
    text:   paymentSuccess
      ? `Payment successful. PayId: ${payId}`
      : `Payment failed. pgResponseCode: ${pgResponseCode}. PayId: ${payId}`,
  });

  const updatedOrder = await order.save();
  return { order: updatedOrder, paymentSuccess };
}

/**
 * Retrieves a ProductOrder by its custom `id` field (GET with no state change).
 * @param {string} orderId
 * @returns {Promise<Object>} Mongoose document
 */
async function getExGBPrepaidOrder(orderId) {
  const order = await ProductOrder.findOne({ id: orderId });
  if (!order) {
    const err = new Error(`ProductOrder not found: ${orderId}`);
    err.statusCode = 404;
    throw err;
  }
  return order;
}

module.exports = { confirmExGBPrepaidOrder, getExGBPrepaidOrder };