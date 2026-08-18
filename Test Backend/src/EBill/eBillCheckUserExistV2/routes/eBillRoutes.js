const express = require('express');
const router = express.Router();

const {
  registerEbill,
  checkEbillUserExists
} = require('../cotrollers/ebillCheckUserExistV2Controller');

// // Existing
// router.post('/ebill/register', registerEbill);

// New endpoint
router.get('/ebill/check-user', checkEbillUserExists);

module.exports = router;