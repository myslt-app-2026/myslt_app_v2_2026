/**
 * Public route for CheckExistCustomer
 * GET /api/NewCon/CheckExistCustomer?NIC=xxx&PP=yyy
 */
const express = require('express');
const router = express.Router();
const CheckExistCustomerController = require('../controllers/CheckExistCustomerController');

router.get('/CheckExistCustomer', CheckExistCustomerController.check);

module.exports = router;
