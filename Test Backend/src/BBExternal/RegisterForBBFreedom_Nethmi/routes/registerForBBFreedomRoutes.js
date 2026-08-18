// TMF622 - Product Ordering Management v4
const express = require('express');
const router = express.Router();
const { registerForBBFreedom } = require('../controllers/registerForBBFreedomController');

// POST /tmf-api/productOrderingManagement/v4/productOrder/bbFreedom
router.post('/productOrder/bbFreedom', registerForBBFreedom);

module.exports = router;
