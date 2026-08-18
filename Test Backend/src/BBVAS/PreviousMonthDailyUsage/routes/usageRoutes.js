const express = require("express");
const router = express.Router();
const usageController = require("../controllers/usageController");

router.get("/usage", usageController.getPreviousMonthsDailyUsage);
// router.post("/", usageController.createUsage);

module.exports = router;
