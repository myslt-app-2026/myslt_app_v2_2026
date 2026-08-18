const express = require("express");
const router = express.Router();

const controller = require("../controllers/purchaseExtraGb.controller");

router.post("/", controller.purchaseExtraGb);

module.exports = router;