const express = require("express");

const router = express.Router();

const {
  getAddonsDashboardRequest
} = require("../controllers/addonsDashboardController");

router.get(
  "/GetAddonsDashboard",
  getAddonsDashboardRequest
);

module.exports = router;