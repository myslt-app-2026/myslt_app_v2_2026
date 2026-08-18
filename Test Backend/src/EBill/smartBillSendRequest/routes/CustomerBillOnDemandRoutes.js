// routes/customerBillOnDemandRoutes.js
const express = require("express");
const router = express.Router();
const {
  createCustomerBillOnDemand,
} = require("../controllers/customerBillOnDemandController");

// TMF 678 aligned POST endpoint with optional ?fields=
router.post("/customerBillOnDemand", createCustomerBillOnDemand);

module.exports = router;
