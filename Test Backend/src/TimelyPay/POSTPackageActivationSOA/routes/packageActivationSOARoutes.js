const express = require("express");
const router = express.Router();

const {
  packageActivationSOARequest,
} = require("../controllers/packageActivationSOAController");

router.post("/", packageActivationSOARequest);

module.exports = router;