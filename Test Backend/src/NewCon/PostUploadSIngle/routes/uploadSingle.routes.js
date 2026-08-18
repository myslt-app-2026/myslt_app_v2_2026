// routes/uploadSingle.routes.js

const express = require('express');
const controller = require('../controllers/uploadSingle.controller');

const router = express.Router();

router.post('/', controller.uploadSingle);

module.exports = router;