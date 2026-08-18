const express = require("express");
const controller = require("./serviceInventoryController");

const router = express.Router();

/**
 * TMF638 Service Inventory
 */
router.get("/service", controller.getService);

module.exports = router;
