const express = require('express');
const router = express.Router();
const packageActivationController = require('../controllers/packageActivation.controller');

const validateActivationRequest = (req, res, next) => {
  const { telephoneno, packageid } = req.query;

  const errors = [];

  if (!telephoneno || telephoneno.trim() === '') {
    errors.push({ field: 'telephoneno', message: 'telephoneno query parameter is required.' });
  }

  if (!packageid || packageid.trim() === '') {
    errors.push({ field: 'packageid', message: 'packageid query parameter is required.' });
  }

  if (telephoneno && !/^\+?\d{7,15}$/.test(telephoneno.trim())) {
    errors.push({ field: 'telephoneno', message: 'telephoneno must be a valid phone number (7–15 digits).' });
  }

  if (errors.length > 0) {
    return res.status(400).json({
      code: 400,
      status: 'Bad Request',
      message: 'Validation failed',
      errors,
    });
  }

  next();
};


router.post(
  '/packageActivation',
  validateActivationRequest,
  packageActivationController.activatePackage
);

module.exports = router;
