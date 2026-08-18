const express = require("express");
const router = express.Router();

const {
  weeksUsageRequest,
} = require("../controllers/weeksUsageController");

router.get("/", weeksUsageRequest);

module.exports = router;