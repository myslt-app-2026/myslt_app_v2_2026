const express = require('express');
const router = express.Router();
const sendOTPController = require('../controllers/sendOTPController');

// Route: POST /tmf-api/communicationManagement/v4/communicationMessage
router.post('/communicationMessage', sendOTPController.sendOTP);

module.exports = router;