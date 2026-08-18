const express = require("express");
const router = express.Router();
const controller = require("../controllers/troubleTicketController");

router.get("/:id", controller.getTicketById);

module.exports = router;
