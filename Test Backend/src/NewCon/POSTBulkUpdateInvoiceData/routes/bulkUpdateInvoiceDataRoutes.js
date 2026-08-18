const express = require("express");
const router = express.Router();
const { bulkUpdateInvoiceDataRequest } = require("../controllers/bulkUpdateInvoiceDataController");

router.post("/", bulkUpdateInvoiceDataRequest);

module.exports = router;