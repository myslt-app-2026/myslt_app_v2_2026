const express = require('express');
const router = express.Router();
const { enhancedPreviousDailyUsageRequest } = require('../controllers/enhancedPreviousDailyUsageController');

router.get('/', enhancedPreviousDailyUsageRequest);

module.exports = router;
