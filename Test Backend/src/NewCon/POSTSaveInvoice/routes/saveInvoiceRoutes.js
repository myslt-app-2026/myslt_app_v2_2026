const express = require("express");
const router = express.Router();
const { saveInvoiceRequest } = require("../controllers/saveInvoiceController");

router.post("/", saveInvoiceRequest);

module.exports = router;