const express = require("express");
const router = express.Router();
const { unsubscribeVASBundle } = require("../controllers/productOrderController");

router.post("/vasBundleUnsubscription", unsubscribeVASBundle);

module.exports = router;
