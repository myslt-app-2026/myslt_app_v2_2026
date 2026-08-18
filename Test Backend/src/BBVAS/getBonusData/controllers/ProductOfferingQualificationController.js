// ProductOfferingQualificationController.js
const express = require('express');
const {
  createProductOfferingQualification,
  createBonusDataQualification,
  listProductOfferingQualification,
  retrieveProductOfferingQualification,
  patchProductOfferingQualification,
  deleteProductOfferingQualification
} = require('../services/ProductOfferingQualificationService.js');

const router = express.Router();

// Helper to handle service responses
const handleService = async (res, serviceFunc, ...args) => {
  try {
    const result = await serviceFunc(...args);
    if (result.success) res.status(result.status || 200).json(result.data);
    else res.status(result.status || 400).json({ message: result.message });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};

// Routes
router.post('/productOfferingQualification', (req, res) =>
  handleService(res, createProductOfferingQualification, req.body)
);

// Special route for bonus data qualification
router.post('/bonusDataQualification', (req, res) =>
  handleService(res, createBonusDataQualification, req.body)
);

router.get('/productOfferingQualification', (req, res) =>
  handleService(res, listProductOfferingQualification, req.query)
);

router.get('/productOfferingQualification/:id', (req, res) =>
  handleService(res, retrieveProductOfferingQualification, req.params.id, req.query.fields)
);

router.patch('/productOfferingQualification/:id', (req, res) =>
  handleService(res, patchProductOfferingQualification, req.params.id, req.body)
);

router.delete('/productOfferingQualification/:id', (req, res) =>
  handleService(res, deleteProductOfferingQualification, req.params.id)
);

module.exports = router;
