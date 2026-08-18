const express = require('express');
const router = express.Router();
const { getBonusDataRequest } = require('../controllers/getBonusDataController');

// GET /api/ISPSOA/dashboard/bonus_data?subscriberID=xxx
router.get('/', getBonusDataRequest);

module.exports = router;
