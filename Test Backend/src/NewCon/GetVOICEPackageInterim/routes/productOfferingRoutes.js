/**
 * TMF620 ProductOffering routes (VOICE Interim)
 * GET /tmf-api/productCatalogManagement/v4/GetVOICEPackageInterim?Mode=SLT%20Fiber
 */
const express = require('express');
const router = express.Router();
const ProductOfferingController = require('../controllers/ProductOfferingController');

router.get('/GetVOICEPackageInterim', ProductOfferingController.listProductOfferings);

module.exports = router;
