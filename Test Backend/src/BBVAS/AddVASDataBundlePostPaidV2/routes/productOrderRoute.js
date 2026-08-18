const express = require('express');
const router = express.Router();
const { createProductOrder } = require('../controllers/productOrderController');

// Create a ProductOrder
router.post('/', createProductOrder);

module.exports = router;
