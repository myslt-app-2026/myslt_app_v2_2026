const express = require("express");
const router = express.Router();

const {
  checkExistCustomerRequest,
} = require("../controllers/checkExistCustomerController");

router.get(
  "/CheckExistCustomer",
  checkExistCustomerRequest
);

module.exports = router;