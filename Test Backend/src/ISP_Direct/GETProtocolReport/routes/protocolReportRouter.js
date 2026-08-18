const express = require("express");

const router = express.Router();

const protocolReportController =
require("../controllers/protocolReportController");

router.get(
    "/protocolhistory",
    protocolReportController.getProtocolReport
);

module.exports = router;