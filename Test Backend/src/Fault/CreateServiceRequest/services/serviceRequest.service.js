const ServiceRequest = require('../models/ServiceRequest');

// Create a new Service Request
const create = async (data) => {
  const newRequest = new ServiceRequest(data);
  return await newRequest.save();
};

// Get all Service Requests
const getAll = async () => {
  return await ServiceRequest.find();
};

module.exports = {
  create,
  getAll
};
