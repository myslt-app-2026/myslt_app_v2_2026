// routes/auth.routes.js
const express = require("express");
const router = express.Router();
const otpController = require("../controllers/otpVerificationController");

router.post("/register/otp/verify", otpController.verifyOtp);

module.exports = router;
