const Service = require('../models/ServiceModel');

// PATCH service/{id} to unsubscribe (terminate)
exports.unsubscribeService = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedService = await Service.findOneAndUpdate(
      { id },
      { state: "terminated", endDate: new Date() },
      { new: true }
    );

    if (!updatedService) {
      return res.status(404).json({ message: `Service ${id} not found` });
    }

    return res.status(200).json(updatedService);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// For testing: Create a service
exports.createService = async (req, res) => {
  try {
    const newService = new Service(req.body);
    await newService.save();
    return res.status(201).json(newService);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};
