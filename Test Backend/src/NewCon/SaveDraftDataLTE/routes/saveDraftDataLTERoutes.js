const express = require('express');
const router = express.Router();
const { saveDraftDataLTERequest } = require('../controllers/saveDraftDataLTEController');

router.post('/', saveDraftDataLTERequest);

module.exports = router;
