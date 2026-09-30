const express = require("express");
const router = express.Router();
const controller = require("../controllers/smartBillRegistration.controller");

router.post("/", controller.smartBillRegistration);
router.post(
  "/ebill/SmartBillRegistration",
  controller.smartBillRegistration
);

module.exports = router;