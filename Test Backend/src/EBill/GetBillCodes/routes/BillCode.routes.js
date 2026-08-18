const express = require('express');
const router = express.Router();
const BillCodeController = require('../controllers/BillCode.controller'); 

/**
 * TMF Route: GET /billDeliveryMethod
 * This mounts the resource collection endpoint.
 */
router.get('/billDeliveryMethod', BillCodeController.getBillCodes);

module.exports = router;