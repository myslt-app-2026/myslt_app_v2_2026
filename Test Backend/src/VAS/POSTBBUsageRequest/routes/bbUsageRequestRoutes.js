const express = require("express");
const router = express.Router();

const {
  bbUsageRequestHandler
} = require("../controllers/bbUsageRequestController");

router.post("/", bbUsageRequestHandler);

module.exports = router;