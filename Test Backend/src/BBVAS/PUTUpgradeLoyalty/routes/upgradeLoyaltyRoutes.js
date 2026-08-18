const express = require("express");
const router = express.Router();

const controller = require("../controllers/upgradeLoyaltyController");

router.put("/UpgradeLoyalty", controller.upgradeLoyalty);

module.exports = router;