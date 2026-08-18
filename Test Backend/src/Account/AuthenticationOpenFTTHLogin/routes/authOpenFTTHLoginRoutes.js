const express    = require("express");
const router     = express.Router();
const controller = require("../controllers/authOpenFTTHLoginController");

router.post("/AuthenticationOpenFTTHLogin", controller.authenticationOpenFTTHLogin);

module.exports = router;