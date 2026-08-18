const express =
require("express");

const router =
express.Router();

const controller =
require("../controllers/purchaseAdvancedReportsController");

router.post(
    "/PurchaseAdvancedReportsPostPaid",
    controller.purchaseAdvancedReportsPostPaid
);

module.exports = router;