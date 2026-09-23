const express = require("express");
const router = express.Router();

const { getPopupMessageBanner } = require("../controllers/popupMessage.controller");

router.get("/PopupMessageBanner", getPopupMessageBanner);
router.get("/popup", getPopupMessageBanner);
router.get("/", getPopupMessageBanner);

module.exports = router;