const express = require("express");
const router = express.Router();

const {
  currentMonthDailyUsageRequest,
} = require("../controllers/currentMonthDailyUsageController");

router.get("/", currentMonthDailyUsageRequest);

module.exports = router;