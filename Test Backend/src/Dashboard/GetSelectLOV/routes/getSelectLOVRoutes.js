const express = require('express');
const router = express.Router();
const { getSelectLOVRequest } = require('../controllers/getSelectLOVController');

// GET /api/Dashboard/GetSelectLOV
// Optional: ?type=status|severity|priority|ticketType
router.get('/', getSelectLOVRequest);

module.exports = router;
