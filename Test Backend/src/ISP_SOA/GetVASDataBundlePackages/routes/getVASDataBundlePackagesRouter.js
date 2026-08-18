const express = require("express");

const router = express.Router();

const controller =
require("../controller/getVASDataBundlePackagesController");

router.get(
  "/GetVASDataBundlePackages",
  controller.getVASDataBundlePackages
);

module.exports = router;