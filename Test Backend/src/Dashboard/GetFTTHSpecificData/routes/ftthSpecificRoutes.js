const express = require('express');
const router = express.Router();
const ftthSpecificController = require('../controllers/ftthSpecificController');

router.get('/info', ftthSpecificController.fetchSpecificFTTHData);

module.exports = router;