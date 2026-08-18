// TMF653 - Service Test Management v4
const express = require('express');
const router = express.Router();
const { getHealthCheckStatus } = require('../controllers/healthCheckController');

// GET /tmf-api/serviceTestManagement/v4/serviceTest/healthCheck?telephoneNo=xxx&accountNo=xxx
router.get('/serviceTest/healthCheck', getHealthCheckStatus);

module.exports = router;
