const express = require("express");
const router = express.Router();
const controller = require("../controllers/smartBillRegistrationSource.controller");

router.post(
  "/ebill/SmartBillRegistrationSource",
  controller.smartBillRegistrationSource
);

module.exports = router;