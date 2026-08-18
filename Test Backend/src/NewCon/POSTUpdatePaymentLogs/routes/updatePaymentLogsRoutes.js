const express = require("express");
const router = express.Router();

const {
  updatePaymentLogsRequest
} = require("../controllers/updatePaymentLogsController");

router.post("/", updatePaymentLogsRequest);

module.exports = router;