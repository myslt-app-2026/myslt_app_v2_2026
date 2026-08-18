// routes/productOfferingQualificationRoutes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/productOfferingQualificationController");

router.post("/productOfferingQualification", controller.checkProductOfferingQualification);

module.exports = router;

