const express = require("express");
const router = express.Router();

const controller = require("../controllers/validateDataTransferController");

router.get("/ValidateDataTransferSub", controller.validateDataTransferSub);

module.exports = router;