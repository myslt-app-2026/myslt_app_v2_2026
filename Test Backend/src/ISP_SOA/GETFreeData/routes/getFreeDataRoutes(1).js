const express = require('express');
const router = express.Router();
const { getFreeDataRequest } = require('../controllers/getFreeDataController');

// GET /api/ISPSOA/dashboard/free_data?subscriberID=xxx
router.get('/', getFreeDataRequest);

module.exports = router;
