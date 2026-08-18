const express =
require("express");

const router =
express.Router();

const controller =
require("../controllers/getCustConfirmationController");

router.get(
    "/GetCustConfirmation",
    controller.getCustConfirmation
);

module.exports = router;