const express = require('express');
const router = express.Router();
const {
  getDataGiftPackagesMobile
} = require('../controllers/getDataGiftPackagesMobileController');

router.get('/service', getDataGiftPackagesMobile);

module.exports = router;