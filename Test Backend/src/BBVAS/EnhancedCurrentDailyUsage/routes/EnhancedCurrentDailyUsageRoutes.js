const express = require('express');
const router = express.Router();
const EnhancedCurrentDailyUsageController = require('../controllers/EnhancedCurrentDailyUsageController');

// GET /tmf-api/usageManagement/v4/usage/EnhancedCurrentDailyUsage
router.get(
  '/EnhancedCurrentDailyUsage',
  EnhancedCurrentDailyUsageController.getEnhancedCurrentDailyUsage
);

module.exports = router;
