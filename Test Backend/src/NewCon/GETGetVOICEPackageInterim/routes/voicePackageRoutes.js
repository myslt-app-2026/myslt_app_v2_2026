const express = require("express");
const router = express.Router();

const {
  getVOICEPackageInterimRequest,
} = require("../controllers/voicePackageController");

router.get("/GetVOICEPackageInterim", getVOICEPackageInterimRequest);

module.exports = router;