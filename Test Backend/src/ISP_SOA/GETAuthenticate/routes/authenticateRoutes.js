const express = require("express");
const router = express.Router();

const { authenticateRequest } = require("../controllers/authenticateController");

router.get("/", authenticateRequest);

module.exports = router;