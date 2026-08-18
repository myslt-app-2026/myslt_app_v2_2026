/**
 * Public route for VOICE Interim packages
 * GET /api/NewCon/GetVOICEPackageInterim?Mode=SLT%20Fiber
 */
const express = require('express');
const router = express.Router();
const ProductOfferingController = require('../controllers/ProductOfferingController');

router.get('/GetVOICEPackageInterim', ProductOfferingController.listProductOfferings);

module.exports = router;
