const express = require('express');
const router = express.Router();
const { sendFTTHSecCodeRequest } = require('../controllers/sendFTTHSecCodeController');

router.post('/', sendFTTHSecCodeRequest);

module.exports = router;
