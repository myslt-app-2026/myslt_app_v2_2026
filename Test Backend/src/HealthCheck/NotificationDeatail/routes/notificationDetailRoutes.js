// TMF681 - Communication Management v4
const express = require('express');
const router = express.Router();
const { getNotificationDetails } = require('../controllers/notificationDetailController');

// GET /tmf-api/communicationManagement/v4/communicationMessage/notification?telephoneNo=xxx&accountNo=xxx
router.get('/communicationMessage/notification', getNotificationDetails);

module.exports = router;
