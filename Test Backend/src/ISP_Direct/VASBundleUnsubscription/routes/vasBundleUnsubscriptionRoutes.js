const express = require("express");
const router = express.Router();

const vasBundleUnsubscriptionController = require("../controllers/vasBundleUnsubscriptionController");

// TMF-style endpoint
// POST /tmf-api/productOrderingManagement/v4/productOrder/vasDataBundle/unsubscribe
router.post(
  "/productOrder/vasDataBundle/unsubscribe",
  vasBundleUnsubscriptionController.unsubscribeVASBundle
);

// Original ISP Direct-style endpoint
// POST /api/isp-direct/vasdataadd-ons/unsubscribe
router.post(
  "/vasdataadd-ons/unsubscribe",
  vasBundleUnsubscriptionController.unsubscribeVASBundle
);

module.exports = router;