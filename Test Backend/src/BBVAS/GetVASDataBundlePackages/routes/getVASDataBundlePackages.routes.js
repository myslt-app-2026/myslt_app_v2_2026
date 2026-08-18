const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/getVASDataBundlePackages.controller");

router.get("/GetVASDataBundlePackages", controller.getVASDataBundlePackages);

module.exports = router;