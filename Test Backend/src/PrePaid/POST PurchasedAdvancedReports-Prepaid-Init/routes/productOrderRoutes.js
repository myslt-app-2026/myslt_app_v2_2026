const express = require('express');
const router = express.Router();
const productOrderController = require('../controllers/productOrderController');

// Standard TMF path for Product Orders
router.post('/', productOrderController.createProductOrder);

module.exports = router;