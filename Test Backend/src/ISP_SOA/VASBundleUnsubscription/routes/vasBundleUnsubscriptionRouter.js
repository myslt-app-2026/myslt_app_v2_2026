const express = require("express");

const router = express.Router();

const controller =
require("../controllers/vasBundleUnsubscriptionController");

router.post(
    "/ISPVASBundleUnsubscription/:id",
    controller.unsubscribeBundle
);

module.exports = router;