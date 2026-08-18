const express = require('express');
const router = express.Router();
const faultRequestController = require('../controllers/faultRequestController');

router.post('/troubleTicket', faultRequestController.createTroubleTicket);

module.exports = router;
