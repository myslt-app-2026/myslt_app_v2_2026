const serviceRequestService = require('../services/serviceRequest.service');

// POST /tmf-api/serviceRequestManagement/v1/serviceRequest
const createServiceRequest = async (req, res) => {
  try {
    const saved = await serviceRequestService.create(req.body);
    res.status(201).json(saved);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// GET all service requests
const getAllRequests = async (req, res) => {
  try {
    const requests = await serviceRequestService.getAll();
    res.json(requests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createServiceRequest,
  getAllRequests
};
