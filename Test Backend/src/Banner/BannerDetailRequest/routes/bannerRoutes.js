// TMF681 - Communication Management v4
const express = require('express');
const router = express.Router();
const bannerController = require('../controllers/bannerController');

// GET /tmf-api/communicationManagement/v4/communicationMessage/banner?username=randikaslt@gmail.com
router.get('/communicationMessage/banner', bannerController.getBannerDetails);

module.exports = router;
