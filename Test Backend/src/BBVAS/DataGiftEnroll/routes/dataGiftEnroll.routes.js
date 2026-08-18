const express = require("express");
const router = express.Router();
const controller = require("../controllers/dataGiftEnroll.controller");

// TMF POST Endpoint
router.post("/DataGiftEnroll", controller.addDataGiftEnroll);

module.exports = router;
