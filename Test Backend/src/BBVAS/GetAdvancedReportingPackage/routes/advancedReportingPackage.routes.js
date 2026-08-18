const express = require('express');
const router = express.Router();
const controller = require('../controllers/advancedReportingPackage.controller');

// TMF-aligned routes
router.get('/advancedReportingPackage', controller.getAdvancedReportingPackages);
router.get('/advancedReportingPackage/:id', controller.getAdvancedReportingPackageById);

module.exports = router;
