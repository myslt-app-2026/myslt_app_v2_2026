const express    = require("express");
const router     = express.Router();
const controller = require("../controller/exGBPurchasePrepaidInit.controller");

/**
 * TMF622 – Product Ordering Management
 * POST /tmf-api/productOrder/v5/ExGBPurchasePrepaidInit
 */
router.post("/ExGBPurchasePrepaidInit", controller.createExGBPrepaidInit);

module.exports = router;