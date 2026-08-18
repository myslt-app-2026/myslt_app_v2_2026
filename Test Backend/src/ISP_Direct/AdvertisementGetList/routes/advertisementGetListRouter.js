const express = require("express");

const router = express.Router();

const {
    advertisementListRequest
} = require("../controllers/advertisementGetListController");

router.get(
    "/getAdvertisementList",
    advertisementListRequest
);

module.exports = router;