
const express = require('express');
const resendOTPController = require('../controllers/resendOTPController');

const router = express.Router();

// routes/auth.routes.js
router.post('/register/resend-otp', resendOTPController.resendOtp);

module.exports = router;

