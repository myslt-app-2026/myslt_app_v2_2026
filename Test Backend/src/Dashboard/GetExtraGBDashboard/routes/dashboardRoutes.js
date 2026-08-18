const express = require('express');

const router = express.Router();

const dashboardController =
require('../controllers/dashboardController');

router.get(
    '/GetExtraGBDashboard',
    dashboardController.getExtraGBDashboard
);

module.exports = router;