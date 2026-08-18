const express = require("express");
const router = express.Router();

const { updateContactRequest } = require("../controllers/updateContactController");

router.put("/:id", updateContactRequest);

module.exports = router;