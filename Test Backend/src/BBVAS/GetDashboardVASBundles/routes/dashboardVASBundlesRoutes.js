const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/dashboardVASBundlesController");

router.get("/GetDashboardVASBundles", controller.getDashboardVASBundles);

module.exports = router;