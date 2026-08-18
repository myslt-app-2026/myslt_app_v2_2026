const express = require('express');
const router = express.Router();
const { getMyPackageRequest } = require('../controllers/getMyPackageController');

// GET /api/ISPSOA/dashboard/mypackage?subscriberID=xxx
router.get('/', getMyPackageRequest);

module.exports = router;
