const express = require('express');
const router = express.Router();
const controller = require('../controllers/reportTimePeriod.controller');

// TMF-aligned routes
router.get('/reportTimePeriod', controller.getReportTimePeriods);
router.get('/reportTimePeriod/:id', controller.getReportTimePeriodById);

module.exports = router;
