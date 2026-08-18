const express = require('express');
const RegisterController = require('../controllers/registerController');

const router = express.Router();

router.post(
  '/RegisterV2',
  RegisterController.registerV2
);

module.exports = router;
