const express = require("express");
const router = express.Router();

const changeBBPasswordController = require("../controllers/changeBBPasswordController");

// TMF-style endpoint
// PUT /tmf-api/customerManagement/v4/customer/profile/broadbandPassword
router.put(
  "/customer/profile/broadbandPassword",
  changeBBPasswordController.changeBBPassword
);

// Original ISP SOA-style endpoint
// PUT /api/isp-soa/profile/broadbandpassword
router.put(
  "/profile/broadbandpassword",
  changeBBPasswordController.changeBBPassword
);

module.exports = router;