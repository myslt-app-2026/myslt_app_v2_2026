const express = require("express");
const router = express.Router();
const advancedReportController = require("../controllers/advancedReportController");

router.post(
  "/BBVAS/PurchaseAdvancedReportsPostPaid",
  advancedReportController.purchaseAdvancedReportPostPaid
);

module.exports = router;
