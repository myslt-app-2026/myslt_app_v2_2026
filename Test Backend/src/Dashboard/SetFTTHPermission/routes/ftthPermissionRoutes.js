const express = require('express');
const router = express.Router();
const ftthPermissionController = require('../controllers/ftthPermissionController');

router.get('/SetFTTHPermission', ftthPermissionController.setFTTHPermission);

module.exports = router;