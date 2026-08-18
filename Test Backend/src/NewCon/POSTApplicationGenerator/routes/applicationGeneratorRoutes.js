const express = require("express");
const router = express.Router();
const { applicationGeneratorRequest } = require("../controllers/applicationGeneratorController");

router.post("/", applicationGeneratorRequest);

module.exports = router;