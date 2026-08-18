const express = require("express");
const router = express.Router();

const addVASDataBundleController = require("../controllers/addVASDataBundleController");

// TMF-style endpoint
// POST /tmf-api/productOrderingManagement/v4/productOrder/vasDataBundle/enroll
router.post(
  "/productOrder/vasDataBundle/enroll",
  addVASDataBundleController.addVASDataBundle
);

// Original ISP Direct-style endpoint
// POST /api/isp-direct/vasdataadd-ons/enroll
router.post(
  "/vasdataadd-ons/enroll",
  addVASDataBundleController.addVASDataBundle
);

module.exports = router;