const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/getFacilityCheckController");

router.get("/GetFacilityCheckV2", controller.getFacilityCheckV2);

module.exports = router;