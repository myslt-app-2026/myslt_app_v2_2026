// routes/bbExternal.routes.js
const express = require('express');
const router = express.Router();
const controller = require('../controllers/getCurrentBBPackageV2.controller');
const authMiddleware = require("../../../middleware/authMiddleware");



router.get('/',authMiddleware, controller.getCurrentBBPackageV2);

module.exports = router;
