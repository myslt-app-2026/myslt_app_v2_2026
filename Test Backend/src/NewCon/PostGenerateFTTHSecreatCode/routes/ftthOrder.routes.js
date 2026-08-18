// routes/ftthOrder.routes.js

const express = require("express");
const router = express.Router();
const controller = require("../controllers/ftthOrder.controller");

router.post(
  "/",
  controller.generateFTTHSecretCode
);

module.exports = router;