const express = require("express");
const router = express.Router();
const transferDataController = require("../controllers/transferDataController");

router.post(
  "/BBVAS/TransferData",
  transferDataController.transferData
);

module.exports = router;