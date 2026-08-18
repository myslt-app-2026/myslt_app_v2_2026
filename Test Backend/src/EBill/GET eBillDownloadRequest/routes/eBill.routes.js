const express = require('express');
const router = express.Router();
const eBillController = require('../controllers/eBill.controller');

// This route corresponds to the eBillDownloadRequest operation
router.get('/customerBill/:id/eBillDownloadRequest', eBillController.requestBillDownload);

module.exports = router;
