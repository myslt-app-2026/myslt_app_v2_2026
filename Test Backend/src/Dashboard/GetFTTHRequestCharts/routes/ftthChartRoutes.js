const express = require('express');
const router = express.Router();
const ftthChartController = require('../controllers/ftthChartController');

router.get('/GetFTTHRequestCharts', ftthChartController.getFTTHRequestCharts);

module.exports = router;