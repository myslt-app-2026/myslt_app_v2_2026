const express = require("express");
const router = express.Router();

const {
  extraGBRequest,
} = require("../controllers/extraGBController");

router.get("/", extraGBRequest);

module.exports = router;