const express = require('express');
const router = express.Router();
const { createPurchasedProduct } = require('../controller/purchasedProductController');

// POST /tmf-api/purchasedProduct
router.post('/purchasedProduct', createPurchasedProduct);

module.exports = router;
