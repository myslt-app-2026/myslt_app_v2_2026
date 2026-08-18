const express = require("express");
const router = express.Router();

const { dataTransferAmountsRequest } = require("../controllers/dataTransferAmountsController");

router.get("/", dataTransferAmountsRequest);

module.exports = router;