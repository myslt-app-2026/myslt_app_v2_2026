const express = require('express');
const router = express.Router();
const usageController = require('../controllers/usageController');

router.get('/usage/:id', usageController.getUsageById);
router.get('/usage', usageController.getUsageFiltered);

module.exports = router;