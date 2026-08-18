const express = require('express');
const router = express.Router();
const controller = require('../controllers/billDownloadController');

/**
 * Base path (in app): /tmf-api/customerBillManagement/v5
 *
 * Routes:
 * GET  /BillDownloadRequest            -> list with query params
 * POST /BillDownloadRequest            -> create (test seed)
 * GET  /BillDownloadRequest/:id        -> get by id
 * PUT  /BillDownloadRequest/:id        -> update
 */
router.get('/BillDownloadRequest', controller.getList);
router.post('/BillDownloadRequest', controller.create);
router.get('/BillDownloadRequest/:id', controller.getById);
router.put('/BillDownloadRequest/:id', controller.update);

module.exports = router;
