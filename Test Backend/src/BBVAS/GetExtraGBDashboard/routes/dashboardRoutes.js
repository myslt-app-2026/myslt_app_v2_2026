const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController');

// GET /api/Dashboard/GetExtraGBDashboard
router.get('/GetExtraGBDashboard', dashboardController.getExtraGBDashboard);

module.exports = router;
