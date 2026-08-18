const express = require('express');
const router = express.Router();
const { getDashboardVASBundlesRequest } = require('../controllers/getDashboardVASBundlesController');

// GET /api/ISPSOA/dashboard/vas_data?subscriberID=xxx
router.get('/', getDashboardVASBundlesRequest);

module.exports = router;
