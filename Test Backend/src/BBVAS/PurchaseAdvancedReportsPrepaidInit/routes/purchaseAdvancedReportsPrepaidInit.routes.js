const express = require("express");
const router = express.Router();
const controller = require("../controllers/purchaseAdvancedReportsPrepaidInit.controller");

// POST → Initiate a prepaid advanced report purchase (Step 1)
router.post(
  "/BBVAS/PurchaseAdvancedReportsPrepaidInit",
  controller.purchaseAdvancedReportsPrepaidInit
);

module.exports = router;