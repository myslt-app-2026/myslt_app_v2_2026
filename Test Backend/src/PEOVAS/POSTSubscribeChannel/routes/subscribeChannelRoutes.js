const express = require('express');
const router = express.Router();
const controller = require('../controllers/subscribeChannelController');

// Route: POST /tmf-api/purchasedProduct/v1
router.post('/', controller.subscribeChannel);

module.exports = router;