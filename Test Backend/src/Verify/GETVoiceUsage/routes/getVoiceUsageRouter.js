const express =
require("express");

const router =
express.Router();

const controller =
require("../controllers/getVoiceUsageController");

router.get(
    "/GETVoiceUsage",
    controller.getVoiceUsage
);

module.exports = router;