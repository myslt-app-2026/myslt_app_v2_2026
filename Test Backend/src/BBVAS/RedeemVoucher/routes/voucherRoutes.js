const express = require("express");
const router  = express.Router();
const voucherController = require("../controllers/voucherController");

router.post("/", voucherController.redeemVoucher);
router.post("/BBVAS/RedeemVoucher", voucherController.redeemVoucher);

module.exports = router; 