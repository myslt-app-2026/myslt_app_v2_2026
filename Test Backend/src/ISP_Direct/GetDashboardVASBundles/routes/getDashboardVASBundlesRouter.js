const express =
require("express");

const router =
express.Router();

const controller =
require("../controllers/getDashboardVASBundlesController");

router.get(
    "/GetDashboardVASBundles",
    controller.getDashboardVASBundles
);

module.exports = router;