const express = require("express");
const router = express.Router();

const {
  getFTTHMapDataRequest,
} = require("../controllers/ftthMapDataController");

router.get("/GetFTTHMapData", getFTTHMapDataRequest);

module.exports = router;