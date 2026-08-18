const express = require('express');
const router = express.Router();
const { getOrderStatusRequest } = require('../controllers/getOrderStatusController');

router.get('/', getOrderStatusRequest);

module.exports = router;
