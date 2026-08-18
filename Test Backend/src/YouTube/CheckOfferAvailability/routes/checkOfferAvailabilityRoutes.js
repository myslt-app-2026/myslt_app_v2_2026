const express = require("express");
const router = express.Router();

const {
  checkOfferAvailabilityRequest,
} = require("../controllers/checkOfferAvailabilityController");

router.get("/", checkOfferAvailabilityRequest);

module.exports = router;