const express = require('express');
const router = express.Router();
const { getBBFreedomStatus } = require('../controllers/getBBFreedomStatusController');

router.get('/GetBBFreedomStatus', getBBFreedomStatus);

module.exports = router;