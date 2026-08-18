const express = require("express");
const router = express.Router();
const { myPackageRequest } = require("../controllers/myPackageController");

router.get("/", myPackageRequest);

module.exports = router;
