const express = require("express");
const router = express.Router();

const getPeoTVGOAccessTokenController = require(
  "../controllers/getPeoTVGOAccessTokenController"
);

// Account endpoint
// GET /api/Account/peoTVGO/accessToken
router.get(
  "/peoTVGO/accessToken",
  getPeoTVGOAccessTokenController.getPeoTVGOAccessToken
);

// TMF-style endpoint
// GET /tmf-api/customerManagement/v4/customer/peoTVGO/accessToken
router.get(
  "/customer/peoTVGO/accessToken",
  getPeoTVGOAccessTokenController.getPeoTVGOAccessToken
);

module.exports = router;