// routes/bbExternal.routes.js
const express = require('express');
const router = express.Router();
const controller = require('../controllers/productOffering.controller');
const authMiddleware = require("../../../middleware/authMiddleware");



// GetBBPackagesV2
router.get('/', authMiddleware, controller.getBBPackagesV2);

module.exports = router;
