const express = require('express');
const router = express.Router();
const confirmController = require('../controllers/confirmOrderController');

// Standard TMF path for Product Order creation/execution
router.post('/', confirmController.confirmProductOrder);

module.exports = router;