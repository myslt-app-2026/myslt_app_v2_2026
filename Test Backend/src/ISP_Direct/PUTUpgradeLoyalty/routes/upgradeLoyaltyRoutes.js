const express = require("express");
const router = express.Router();

const { upgradeLoyaltyRequest } = require("../controllers/upgradeLoyaltyController");

router.put("/", upgradeLoyaltyRequest);

module.exports = router;