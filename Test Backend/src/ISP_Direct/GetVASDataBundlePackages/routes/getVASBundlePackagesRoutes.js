const express = require("express");
const router = express.Router();

const getVASBundlePackagesController = require("../controllers/getVASBundlePackagesController");

// TMF-style endpoint
// GET /tmf-api/productCatalogManagement/v4/productOffering/vasDataBundle/packages?basepackage=
router.get(
  "/productOffering/vasDataBundle/packages",
  getVASBundlePackagesController.getVASBundlePackages
);

// Original ISP Direct-style endpoint
// GET /api/isp-direct/vasdataadd-ons/packages?basepackage=
router.get(
  "/vasdataadd-ons/packages",
  getVASBundlePackagesController.getVASBundlePackages
);

module.exports = router;