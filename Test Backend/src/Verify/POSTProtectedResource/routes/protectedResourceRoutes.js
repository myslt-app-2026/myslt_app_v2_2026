const express = require("express");
const router = express.Router();

const authMiddleware = require("../../../middleware/authMiddleware");
const { protectedResourceRequest } = require("../controllers/protectedResourceController");

router.post("/", authMiddleware, protectedResourceRequest);

module.exports = router;