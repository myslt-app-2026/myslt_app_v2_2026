const express = require("express");
const router = express.Router();

const {
  protocolReportRequest
} = require("../controllers/protocolReportController");

router.get("/", protocolReportRequest);

module.exports = router;