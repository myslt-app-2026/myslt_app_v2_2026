const express = require('express');
const router = express.Router();
const controller = require('../controllers/registerSmartEBillController');

// Route: POST /tmf-api/customerBill/v4
router.post('/', controller.registerSmartEBill);

module.exports = router;