const express = require("express");
const router = express.Router();
const customerController = require("../controllers/customer.controller");

// The route for updating a customer's contact information
// This follows the TMF629 standard for a PUT operation on a specific customer ID.
router.put(
  "/tmf-api/customerManagement/v5/customer/:id",
  customerController.updateCustomerContact
);

module.exports = router;
