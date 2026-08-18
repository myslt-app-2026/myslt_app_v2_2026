// routes/bbExternal.routes.js
const express = require('express');
const router = express.Router();
const controller = require('../controllers/getBBPackageComparison.controller');
const authMiddleware = require("../../../middleware/authMiddleware");



router.get('/', authMiddleware,controller.getBBPackageComparison);

module.exports = router;
