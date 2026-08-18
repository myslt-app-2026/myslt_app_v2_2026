const express = require("express");
const router = express.Router();
const { getInvoiceDataRequest } = require("../controllers/getInvoiceDataController");

router.get("/", getInvoiceDataRequest);

module.exports = router;