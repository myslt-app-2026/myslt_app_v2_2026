//src/controllers/vasDataBundle.controller.js
const vasService = require("../services/vasDataBundle.service.js");

exports.addVASDataBundle = async (req, res) => {
  try {
    const vasBundle = await vasService.createVASBundle(req.body);
    res.status(201).json({
      code: "201",
      message: "VAS Data Bundle Prepaid Initiated Successfully",
      data: vasBundle,
    });
  } catch (error) {
    res.status(500).json({
      code: "500",
      message: "Failed to initiate VAS Data Bundle",
      error: error.message,
    });
  }
};

exports.getAllVASBundles = async (req, res) => {
  try {
    const bundles = await vasService.getVASBundles();
    res.status(200).json(bundles);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
