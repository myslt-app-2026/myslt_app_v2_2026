const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/freeDataController");

router.get("/FreeData", controller.getFreeData);

module.exports = router;