const express = require("express");
const router = express.Router();
const { vasBundleUnsubscription } = require("../controllers/UnsubscriptionController");

router.post("/", vasBundleUnsubscription);

module.exports = router;