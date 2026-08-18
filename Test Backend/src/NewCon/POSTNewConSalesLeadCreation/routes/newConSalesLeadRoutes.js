const express = require("express");
const router = express.Router();

const {
  newConSalesLeadRequest
} = require("../controllers/newConSalesLeadController");

router.post("/", newConSalesLeadRequest);

module.exports = router;