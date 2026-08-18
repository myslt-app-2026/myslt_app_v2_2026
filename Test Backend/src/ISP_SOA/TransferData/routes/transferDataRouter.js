const express = require("express");

const router = express.Router();

const controller =
require("../controllers/transferDataController");

router.post(
    "/TransferData",
    controller.transferData
);

module.exports = router;