const express = require("express");
const router = express.Router();

const redeemVoucherController = require("../controllers/redeemVoucherController");

// TMF-style endpoint
// POST /tmf-api/productOrderingManagement/v4/productOrder/redeemVoucher
router.post("/productOrder/redeemVoucher", redeemVoucherController.redeemVoucher);

// Original ISP SOA-style endpoint
// POST /api/isp-soa/redeemvoucher
router.post("/redeemvoucher", redeemVoucherController.redeemVoucher);

module.exports = router;