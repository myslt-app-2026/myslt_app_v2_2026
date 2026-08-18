const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/getCityListController");

router.get("/GetCityList", controller.getCityList);

module.exports = router;