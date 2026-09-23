const express = require('express');
const router = express.Router();
const controller = require('../controllers/pushNotification.controller');

router.post('/pushNotifications', controller.sendPushNotification);
router.post('/push', controller.sendPushNotification);
router.post('/', controller.sendPushNotification);

module.exports = router;
