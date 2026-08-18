const express = require("express");
const router = express.Router();

const profileController = require("../controllers/profileController");

// VAS GET Profile endpoint
// GET /api/vas/profile
router.get("/profile", profileController.getProfile);

// TMF-style Customer Management endpoint
// GET /tmf-api/customerManagement/v4/customer/profile
router.get("/customer/profile", profileController.getProfile);

module.exports = router;