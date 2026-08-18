const express = require("express");
const router = express.Router();

const { changeBBPasswordRequest } = require("../controllers/changeBBPasswordController");

router.put("/", changeBBPasswordRequest);

module.exports = router;