const express = require("express");
const router = express.Router();

const upgradeLoyaltyController = require("../controllers/upgradeLoyaltyController");

// TMF-style endpoint
// PUT /tmf-api/customerManagement/v4/customer/loyalty/claim
router.put("/customer/loyalty/claim", upgradeLoyaltyController.upgradeLoyalty);

// Original ISP SOA-style endpoint
// PUT /api/isp-soa/loyalty/claim
router.put("/loyalty/claim", upgradeLoyaltyController.upgradeLoyalty);

module.exports = router;