const express = require('express');
const router = express.Router();
const { updateUserInfoRequest } = require('../controllers/updateUserInfoController');

router.post('/', updateUserInfoRequest);

module.exports = router;