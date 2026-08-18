const express = require("express");
const router = express.Router();

const {
  callForwardingRequest,
} = require("../controllers/callForwardingRequestController");

router.get("/", callForwardingRequest);

module.exports = router;