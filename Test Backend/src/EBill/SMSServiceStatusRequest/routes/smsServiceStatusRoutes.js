const express = require("express");
const router = express.Router();
const { smsServiceStatusRequest } = require("../controllers/smsServiceStatusController");

router.get("/", smsServiceStatusRequest);

module.exports = router;