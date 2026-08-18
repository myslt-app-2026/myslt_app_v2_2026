const express = require('express');
const router = express.Router();
const ftthLoginController = require('../controllers/ftthLoginController');

router.get('/FTTHDashboardLogin', ftthLoginController.ftthDashboardLogin);

module.exports = router;