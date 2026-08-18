const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/bonusDataController");

router.get("/BonusData", controller.getBonusData);

module.exports = router;