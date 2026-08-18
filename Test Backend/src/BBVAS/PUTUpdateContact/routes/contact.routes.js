const express = require("express");
const router = express.Router();
const contactController = require("../controllers/contact.controller");

// TMF-style route
router.put("/customerManagement/v4/updateContact/:id", contactController.updateContact);

module.exports = router;
