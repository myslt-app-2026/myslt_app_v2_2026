const express = require('express');
const router = express.Router();
const { checkCallForwardingRequest } = require('../controllers/checkCallForwardingController');

router.get('/', checkCallForwardingRequest);

module.exports = router;