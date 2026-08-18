const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/dataGiftEnrollPrepaidConfirm.controller");

router.post("/DataGiftEnrollPrepaidConfirm", controller.confirmDataGiftEnrollPrepaid);

module.exports = router;