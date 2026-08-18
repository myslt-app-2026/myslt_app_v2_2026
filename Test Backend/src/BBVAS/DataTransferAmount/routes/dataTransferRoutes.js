const express = require("express");
const router = express.Router();
const dataTransferController = require("../controllers/dataTransferController");

router.get(
  "/BBVAS/GetDataTransferAmounts",
  dataTransferController.getDataTransferAmounts
);

module.exports = router;
