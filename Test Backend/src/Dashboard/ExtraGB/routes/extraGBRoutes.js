const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/extraGBController");

router.get("/ExtraGB", controller.getExtraGB);

module.exports = router;