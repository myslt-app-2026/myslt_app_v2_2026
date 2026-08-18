const express =
require("express");

const router =
express.Router();

const controller =
require("../controllers/getPurchaseHistoryController");

router.get(
    "/getpurchasehistory",
    controller.getPurchaseHistory
);

module.exports = router;