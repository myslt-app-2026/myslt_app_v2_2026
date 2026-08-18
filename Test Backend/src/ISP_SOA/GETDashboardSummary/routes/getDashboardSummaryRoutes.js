const express = require('express');
const router = express.Router();
const { getDashboardSummaryRequest } = require('../controllers/getDashboardSummaryController');

router.get('/', getDashboardSummaryRequest);

module.exports = router;