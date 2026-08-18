const express = require("express");
const controller = require("./productInventoryContoller");

const router = express.Router();

/**
 * TMF637 Product Inventory
 * GET /tmf-api/productInventory/v4/product
 */
router.get("/product", controller.getProduct);

module.exports = router;
