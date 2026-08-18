const express = require("express");
const router = express.Router();

const controller = require("../controllers/purchaseAdvancedReporting.controller");

router.post("/", controller.purchaseAdvancedReporting);

module.exports = router;