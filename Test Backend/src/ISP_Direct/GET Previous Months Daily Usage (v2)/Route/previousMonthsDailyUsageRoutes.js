const express = require("express");
const router = express.Router();

const {
  previousMonthsDailyUsageRequest,
} = require("../controllers/previousMonthsDailyUsageController");

router.get("/", previousMonthsDailyUsageRequest);

module.exports = router;