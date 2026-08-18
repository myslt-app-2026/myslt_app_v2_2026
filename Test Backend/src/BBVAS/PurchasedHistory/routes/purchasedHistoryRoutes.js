// src/BBVAS/PurchasedHistory/routes/purchasedHistoryRoutes.js

const express = require('express');
const router = express.Router();
const { getPurchasedHistory } = require('../controllers/purchasedHistoryController');

router.get('/purchasedHistory', getPurchasedHistory);

module.exports = router;