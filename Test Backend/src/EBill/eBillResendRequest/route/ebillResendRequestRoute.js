const express = require("express");
const router = express.Router();

const {
  eBillResendRequest
} = require("../controller/ebillResentRequestController");

router.post("/ebill/eBillResendRequest", eBillResendRequest);

module.exports = router;