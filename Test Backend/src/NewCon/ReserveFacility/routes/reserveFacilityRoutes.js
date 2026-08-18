const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/reserveFacilityController");

router.post("/ReserveFacility", controller.reserveFacility);

module.exports = router;