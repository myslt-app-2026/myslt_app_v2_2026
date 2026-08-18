const express = require('express');
const router = express.Router();
const controller = require('../controllers/pushNotification.controller');

router.post('/pushNotifications', controller.sendPushNotification);

module.exports = router;
