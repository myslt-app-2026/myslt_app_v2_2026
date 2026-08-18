const express = require('express');
const router = express.Router();
const controller = require('../controllers/serviceRequest.controller');

// TMF-standard routes
router.post('/tmf-api/serviceRequestManagement/v1/serviceRequest', controller.createServiceRequest);
router.get('/tmf-api/serviceRequestManagement/v1/serviceRequest', controller.getAllRequests);

module.exports = router;
