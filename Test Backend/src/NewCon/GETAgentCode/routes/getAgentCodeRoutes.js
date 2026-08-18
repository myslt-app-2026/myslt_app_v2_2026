const express = require('express');
const router = express.Router();
const { getAgentCodeRequest } = require('../controllers/getAgentCodeController');

router.get('/', getAgentCodeRequest);

module.exports = router;
