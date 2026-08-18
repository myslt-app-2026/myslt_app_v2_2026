const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/validateBBPurchaseRequest.controller");

router.get("/ValidateBBPurchaseRequest", controller.validateBBPurchaseRequest);

module.exports = router;