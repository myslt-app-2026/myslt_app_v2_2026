const express = require('express');
const router = express.Router();
const { getFaultDashboardRequest } = require('../controllers/getFaultDashboardController');

// GET /api/Dashboard/GetFaultDashboard
router.get('/', getFaultDashboardRequest);

module.exports = router;
