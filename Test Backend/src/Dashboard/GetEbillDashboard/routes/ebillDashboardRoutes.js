const express = require("express");

const router = express.Router();

const {
  getEbillDashboardRequest
} = require("../controllers/ebillDashboardController");

router.get(
  "/GetEbillDashboard",
  getEbillDashboardRequest
);

module.exports = router;