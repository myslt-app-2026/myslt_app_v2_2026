/**
 * TMF620 ProductOffering routes
 * GET /tmf-api/productCatalogManagement/v4/productOffering?accessType=4G
 */
const express = require('express');
const router = express.Router();
const ProductOfferingController = require('../controllers/ProductOfferingController');

router.get('/productOffering', ProductOfferingController.listProductOfferings);

module.exports = router;
