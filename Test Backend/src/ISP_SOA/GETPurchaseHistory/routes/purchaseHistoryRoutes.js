const express = require("express");
const router = express.Router();

const purchaseHistoryController =
require("../controllers/purchaseHistoryController");

router.get("/", purchaseHistoryController.getPurchaseHistory);

module.exports = router;