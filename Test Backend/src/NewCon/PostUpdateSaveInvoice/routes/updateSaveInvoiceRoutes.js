const express = require("express");
const router = express.Router();
const { updateSaveInvoiceRequest } = require("../controllers/updateSaveInvoiceController");

router.post("/", updateSaveInvoiceRequest);

module.exports = router;