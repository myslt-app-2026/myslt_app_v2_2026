// src/routes/usage.routes.js
const express = require("express");
const router = express.Router();
const usageController = require("../controllers/usageController");

// Weekly Usage endpoint
router.get("/usage/weekly/:subscriberId", usageController.getWeeklyUsage);

module.exports = router;
