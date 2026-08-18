const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');

// Create service 
router.post('/service', serviceController.createService);

// Unsubscribe (terminate) service
router.patch('/service/:id', serviceController.unsubscribeService);

module.exports = router;
