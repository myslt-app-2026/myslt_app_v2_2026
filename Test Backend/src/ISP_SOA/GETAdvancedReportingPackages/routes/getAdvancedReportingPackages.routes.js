const express = require("express");
const router = express.Router();

const controller = require("../controllers/getAdvancedReportingPackages.controller");

router.get("/", controller.getAdvancedReportingPackages);

module.exports = router;