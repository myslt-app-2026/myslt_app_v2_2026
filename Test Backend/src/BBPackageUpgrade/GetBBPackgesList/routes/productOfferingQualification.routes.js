const express = require('express');
const router = express.Router();
const controller =
  require('../controllers/productOfferingQualification.controller');

router.get(
  '/productOfferingQualification',
  controller.getProductOfferingQualification
);

module.exports = router;
