const express = require("express");
const router = express.Router();
const {
  getPurchaseHistoryRequest,
} = require("../controllers/getPurchaseHistoryController");

router.get("/", getPurchaseHistoryRequest);

module.exports = router;
