const express = require('express');
const router = express.Router();
const { enhancedCurrentDailyUsageRequest } = require('../controllers/enhancedCurrentDailyUsageController');

router.get('/', enhancedCurrentDailyUsageRequest);

module.exports = router;
