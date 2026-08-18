const express =
require("express");

const router =
express.Router();

const controller =
require("../controllers/addVASDataBundlePostPaidController");

router.post(
    "/AddVASDataBundlePostPaid",
    controller.addVASDataBundlePostPaid
);

module.exports = router;