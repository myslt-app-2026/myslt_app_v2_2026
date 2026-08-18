const express = require("express");
const router = express.Router();
const dataGiftController = require("../controllers/dataGiftController");

router.get("/usage/:subscriberID", dataGiftController.listDataGiftPackages);

module.exports = router;
