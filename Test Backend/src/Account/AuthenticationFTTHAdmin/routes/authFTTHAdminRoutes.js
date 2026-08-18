const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/authFTTHAdminController");

router.post("/AuthenticationFTTHAdmin", controller.authenticationFTTHAdmin);

module.exports = router;