const express = require("express");
const router = express.Router();

const authMiddleware = require("../../middleware/authMiddleware");
const controller = require("./extraGBController");

/**
 * TMF622
 */
//ExGBPurchasePrepaidInit
router.post(
  "/productOrder",
  authMiddleware,
  controller.createProductOrder
);

//ExGBPurchasePrepaidConfirm
router.patch(
  "/productOrder/:id",
  authMiddleware,
  controller.updateProductOrder
);

module.exports = router;
