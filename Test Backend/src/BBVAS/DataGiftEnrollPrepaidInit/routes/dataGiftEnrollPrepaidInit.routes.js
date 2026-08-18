const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/dataGiftEnrollPrepaidInit.controller");

router.post("/DataGiftEnrollPrepaidInit", controller.createDataGiftEnrollPrepaidInit);

module.exports = router;