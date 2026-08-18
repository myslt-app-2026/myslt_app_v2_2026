const express = require("express");
const router = express.Router();


router.use(express.json());
router.use(express.urlencoded({ extended: true }));

const {
  addVasBundleConfirm
} = require("../controllers/vasBundleConfirm.controller");

/**
 * POST – Add VAS Data Bundle Prepaid Confirm
 */
router.post(
  "/productOrdering/v4/vas/prepaid/confirm",
  addVasBundleConfirm
);

module.exports = router;
