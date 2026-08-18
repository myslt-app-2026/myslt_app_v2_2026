const express = require('express');
const router = express.Router();
const { updateAgentCodeRequest } = require('../controllers/updateAgentCodeController');

router.post('/', updateAgentCodeRequest);

module.exports = router;
