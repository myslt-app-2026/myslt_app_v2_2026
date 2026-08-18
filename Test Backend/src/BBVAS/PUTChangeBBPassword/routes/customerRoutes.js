const express = require("express");
const router = express.Router();
const { changeBBPasswordController } = require("../controllers/customerController");

router.put("/", changeBBPasswordController);

module.exports = router;