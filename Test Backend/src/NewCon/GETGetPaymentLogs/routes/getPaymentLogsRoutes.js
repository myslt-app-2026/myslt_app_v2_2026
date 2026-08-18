const express = require("express");
const router = express.Router();

const {
  getPaymentLogsRequest
} = require("../controllers/getPaymentLogsController");

router.get("/", getPaymentLogsRequest);

module.exports = router;