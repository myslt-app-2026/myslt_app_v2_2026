const express = require("express");
const router = express.Router();

const {
  getTokenStatusRequest
} = require("../controllers/getTokenStatusController");

router.post("/", getTokenStatusRequest);

module.exports = router;