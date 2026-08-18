const FTTHFullData = require('../models/ftthModel');

exports.getFTTHFullData = async (req, res) => {
  try {
    const { serviceId } = req.query;

    if (!serviceId) {
      return res.status(400).json({ message: "serviceId is required as a query parameter." });
    }

    // In a real scenario, you might aggregate this from multiple DB collections
    const data = await FTTHFullData.findOne({ "service.id": serviceId });

    if (!data) {
      return res.status(404).json({ message: "FTTH data not found for the provided serviceId." });
    }

    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Server Error", error: err.message });
  }
};