const express = require("express");
const router = express.Router();
const vasController = require("../controllers/vasController");

// Define relative path only (let app.js handle the prefix)
router.post(
  "/",
  vasController.addVASDataBundlePrepaidConfirm
);

module.exports = router;
