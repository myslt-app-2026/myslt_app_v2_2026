const express = require("express");
const router = express.Router();

const {
  advertisementListRequest
} = require("../controllers/advertisementListController");

router.get("/", advertisementListRequest);

module.exports = router;