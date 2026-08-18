const express = require("express");
const router = express.Router();

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

const {
  unsubscribeAdvancedReports
} = require("../controllers/unsubscribeAdvancedReports.controller");

/**
 * POST – Unsubscribe Advanced Reports
 */
router.post(
  "/ServiceActivationAndConfiguration/v4/advanced-reports/unsubscribe",
  unsubscribeAdvancedReports
);

module.exports = router;
