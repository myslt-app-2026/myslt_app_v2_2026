const express = require("express");
const router = express.Router();
const dataGiftController = require("../controllers/dataGiftController");

router.get(
  "/validateDataGiftSub",
  dataGiftController.validateDataGiftSub
);

router.get(
  "/validateDataGiftSub/:subscriberId",
  dataGiftController.validateDataGiftSub
);

router.get(
  "/validateDataGiftSub/:subscriberId/:giftId/:sponsorId",
  dataGiftController.validateDataGiftSub
);

module.exports = router;
