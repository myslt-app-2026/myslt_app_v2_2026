const express = require("express");
const router = express.Router();

const { validateDataTransferSubRequest } = require("../controllers/validateDataTransferSubController");

router.get("/", validateDataTransferSubRequest);

module.exports = router;