const express = require('express');
const router = express.Router();
const verifyOTPController = require('../controllers/verifyOTPController');

// Route: POST /tmf-api/digitalIdentity/v4/digitalIdentity/:id/checkCredential
// OR simple: POST /checkCredential
router.post('/checkCredential', verifyOTPController.verifyOTP);

module.exports = router;