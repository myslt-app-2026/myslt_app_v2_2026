const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/createFTTHAdminController");

router.post("/CreateFTTHAdmin", controller.createFTTHAdmin);

module.exports = router;