const express = require('express');
const router = express.Router();
const { getUserInfoRequest } = require('../controllers/getUserInfoController');

router.get('/', getUserInfoRequest);

module.exports = router;