const express = require("express");
const router = express.Router();
const dataGiftController = require("../controller/dataGiftEnrollInit.controller");

router.post("/DataGiftEnrollInit", dataGiftController.createDataGiftEnrollInit);

module.exports = router;
