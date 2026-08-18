const express = require("express");
const router = express.Router();

const happyDayController = require("../controllers/happyDayController");

// TMF-style endpoint
// POST /tmf-api/productOrderingManagement/v4/productOrder/happyDay
router.post("/productOrder/happyDay", happyDayController.enrollHappyDay);

// Original ISP SOA-style endpoint
// POST /api/isp-soa/happyday/enroll
router.post("/happyday/enroll", happyDayController.enrollHappyDay);

module.exports = router;