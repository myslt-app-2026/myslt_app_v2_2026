const express = require("express");
const router = express.Router();
const purchaseController = require("../Controller/purchaseController");

router.post("/purchase", purchaseController.createPurchase);

module.exports = router;
