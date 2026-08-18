const express = require("express");
const router = express.Router();

const {
  packageActivation,
  packageActivationTMF,
} = require("../controllers/youtubeOfferController");

// Custom assigned endpoint
// POST /api/mySltBss/youTube/uOffer
router.post("/youTube/uOffer", packageActivation);

// TMF640 style endpoint
// POST /tmf-api/ServiceActivationAndConfiguration/v4/service
router.post("/service", packageActivationTMF);

module.exports = router;