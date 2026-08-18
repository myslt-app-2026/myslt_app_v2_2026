const express = require("express");
const router = express.Router();

const dashboardController =
require("../controllers/dashboardController");

router.get(
  "/GetFTTHNCDashboard",
  dashboardController.getFTTHNCDashboard
);

module.exports = router;