const express = require('express');
const router = express.Router();
const ftthController = require('../controllers/ftthController');

// Standardized GET endpoint
router.get('/', ftthController.getFTTHFullData);

module.exports = router;