const express = require("express");
const router = express.Router();

const controller = require("../controllers/getExtraGbPackages.controller");

router.get("/", controller.getExtraGbPackages);

module.exports = router;