// routes/uploadMultipart.routes.js

const express = require('express');
const multer = require('multer');
const controller = require('../controllers/uploadMultipart.controller');

const router = express.Router();

// Multer config
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) =>
    cb(null, Date.now() + '-' + file.originalname)
});

const upload = multer({ storage });

// Route
router.post(
  '/',
  upload.fields([
    { name: 'nicfront_file' },
    { name: 'nicback_file' },
    { name: 'pp_file' },
    { name: 'application_file' },
    { name: 'billingproof_file' }
  ]),
  controller.uploadMultipartSingle
);

module.exports = router;