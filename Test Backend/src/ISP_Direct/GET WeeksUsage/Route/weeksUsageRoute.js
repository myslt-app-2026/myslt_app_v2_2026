const express = require("express");
const router = express.Router();

const {
  weeksUsageRequest,
} = require("./../Controller/weeksUsageController");

router.get("/", weeksUsageRequest);

module.exports = router;