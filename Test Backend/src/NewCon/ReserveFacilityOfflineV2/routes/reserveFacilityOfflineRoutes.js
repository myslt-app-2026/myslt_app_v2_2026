const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/reserveFacilityOfflineController");

router.post("/ReserveFacilityOfflineV2", controller.reserveFacilityOfflineV2);

module.exports = router;