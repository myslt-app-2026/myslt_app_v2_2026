const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/exGBPurchasePrepaidConfirm.controller");

/**
 * TMF622 – Product Ordering Management
 * GET /tmf-api/productOrder/v5/ExGBPurchasePrepaidConfirm
 *
 * Query params: orderId, pgResponseCode, payId
 */
router.get("/ExGBPurchasePrepaidConfirm", controller.confirmExGBPrepaid);

module.exports = router;