const express = require("express");
const router = express.Router();
const { billStatusRequest } = require("../controllers/billStatusController");

router.get("/", billStatusRequest);

module.exports = router;