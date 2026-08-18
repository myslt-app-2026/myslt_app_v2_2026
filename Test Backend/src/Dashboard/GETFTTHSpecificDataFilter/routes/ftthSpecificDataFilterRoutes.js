const express = require("express");
const router = express.Router();

const {
  getFTTHSpecificDataFilterRequest,
} = require("../controllers/ftthSpecificDataFilterController");

router.get(
  "/GetFTTHSpecificDataFilter",
  getFTTHSpecificDataFilterRequest
);

module.exports = router;