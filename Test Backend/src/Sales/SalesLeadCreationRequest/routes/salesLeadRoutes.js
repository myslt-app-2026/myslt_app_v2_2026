const express = require('express');
const router = express.Router();
const salesLeadController = require('../controllers/salesLeadController');

router.post('/salesLead', salesLeadController.createSalesLead);

module.exports = router;
