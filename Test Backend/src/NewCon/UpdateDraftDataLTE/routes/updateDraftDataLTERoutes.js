const express = require('express');
const router = express.Router();
const { updateDraftDataLTERequest } = require('../controllers/updateDraftDataLTEController');

router.post('/', updateDraftDataLTERequest);

module.exports = router;
