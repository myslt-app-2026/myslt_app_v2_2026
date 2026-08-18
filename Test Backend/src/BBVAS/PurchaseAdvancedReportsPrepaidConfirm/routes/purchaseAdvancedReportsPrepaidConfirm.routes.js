const express = require("express");
const router = express.Router();
const controller = require("../controllers/purchaseAdvancedReportsPrepaidConfirm.controller");

// POST → Confirm a prepaid advanced report purchase (Step 2)
router.post(
  "/BBVAS/PurchaseAdvancedReportsPrepaidConfirm",
  controller.purchaseAdvancedReportsPrepaidConfirm
);

module.exports = router;