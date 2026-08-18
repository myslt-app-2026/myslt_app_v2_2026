const express = require('express');
const router = express.Router();
const ProductOfferingPriceController = require('../controllers/ProductOfferingPriceController');

router.get('/productOfferingPrice', ProductOfferingPriceController.listProductOfferingPrices);

router.get('/productOfferingPrice/:id', ProductOfferingPriceController.retrieveProductOfferingPrice);

module.exports = router;
