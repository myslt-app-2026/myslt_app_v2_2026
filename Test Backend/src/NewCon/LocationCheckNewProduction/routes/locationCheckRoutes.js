const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/locationCheckController");

router.post("/LocationCheckNewProduction", controller.locationCheckNewProduction);

module.exports = router;