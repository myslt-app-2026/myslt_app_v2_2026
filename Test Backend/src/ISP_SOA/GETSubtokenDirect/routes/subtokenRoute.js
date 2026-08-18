const express = require("express");
const router = express.Router();

const subtokenController =
require("../controllers/subtokenController");

router.get("/", subtokenController.getSubscriberToken);

module.exports = router;