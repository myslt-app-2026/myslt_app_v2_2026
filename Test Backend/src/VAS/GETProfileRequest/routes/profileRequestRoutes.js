const express = require("express");
const router = express.Router();

const { profileRequestController } = require("../controllers/profileRequestController");

router.get("/", profileRequestController);

module.exports = router;