const express = require('express');
const router = express.Router();
const { checkCRMLeadStatusRequest } = require('../controllers/checkCRMLeadStatusController');

router.get('/', checkCRMLeadStatusRequest);

module.exports = router;
