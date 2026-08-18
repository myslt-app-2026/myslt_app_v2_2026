//src/routes/vasDataBundle.rotes.js
const express = require("express");
const router = express.Router();
const vasController = require("../controllers/vasDataBundle.controller");
// TMF-aligned endpoints
router.post(
  "/",
  vasController.addVASDataBundle
);

//router.get("/",vasController.getAllVASBundles);

module.exports = router;
