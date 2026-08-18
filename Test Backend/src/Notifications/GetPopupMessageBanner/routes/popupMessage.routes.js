const express = require("express");
const router = express.Router();

const { getPopupMessageBanner } = require("../controllers/popupMessage.controller");

router.get("/PopupMessageBanner", getPopupMessageBanner);

module.exports = router;