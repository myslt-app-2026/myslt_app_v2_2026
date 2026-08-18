const express = require("express");
const router = express.Router();
const { bonusDataRequest } = require("../controllers/bonusDataController");

router.get("/", bonusDataRequest);

module.exports = router;
