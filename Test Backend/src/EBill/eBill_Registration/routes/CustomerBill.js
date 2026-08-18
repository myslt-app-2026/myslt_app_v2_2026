const express = require('express');
const router = express.Router();

const { registerEbill } = require('../controllers/customerBillController');

router.post('/ebill/register', registerEbill);

module.exports = router;