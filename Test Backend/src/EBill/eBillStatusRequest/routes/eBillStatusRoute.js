const express = require("express");
const { eBillStatusRequest } = require("../controllers/eBillStatusController");

const router = express.Router();

// GET /tmf-api/eBillStatusRequest
router.get("/eBillStatusRequest", eBillStatusRequest);

module.exports = router;
