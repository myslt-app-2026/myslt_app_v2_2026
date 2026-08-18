const express = require('express');
const router = express.Router();
const { saveDraftDataRequest } = require('../controllers/saveDraftDataController');

router.post('/', saveDraftDataRequest);

module.exports = router;
