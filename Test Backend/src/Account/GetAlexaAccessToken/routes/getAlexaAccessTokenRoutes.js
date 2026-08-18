const express = require('express');
const router = express.Router();
const { getAlexaAccessTokenRequest } = require('../controllers/getAlexaAccessTokenController');

router.post('/', getAlexaAccessTokenRequest);

module.exports = router;