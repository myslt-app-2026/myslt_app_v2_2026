const express = require("express");
const router = express.Router();
const { freeDataRequest } = require("../controllers/freeDataController");

router.get("/", freeDataRequest);

module.exports = router;
