// TMF622 - Product Ordering Management v4
const express = require('express');
const router = express.Router();
const ftthStatusController = require('../controllers/ftthStatusController');

// GET /tmf-api/productOrderingManagement/v4/ftthRequest/statusCount?startDate=xxx&endDate=xxx
router.get('/ftthRequest/statusCount', ftthStatusController.getFTTHRequestStatusCount);

module.exports = router;
