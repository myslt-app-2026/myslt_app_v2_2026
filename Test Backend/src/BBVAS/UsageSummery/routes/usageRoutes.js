const express = require("express");
const router = express.Router();
const usageController = require("../controllers/usageController");

// router.get("/usage", usageController.getUsageSummary);
router.get("/usage/:id", usageController.getUsageById);

module.exports = router;
