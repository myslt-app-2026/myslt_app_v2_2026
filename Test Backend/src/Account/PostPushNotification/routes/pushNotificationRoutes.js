const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/pushNotificationController");

router.post("/PostPushNotification", controller.sendPushNotification);

module.exports = router;