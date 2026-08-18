const FTTHSpecificData = require('../models/ftthSpecificModel');

exports.fetchSpecificFTTHData = async (req, res) => {
  try {
    const { serviceId } = req.query;

    if (!serviceId) {
      return res.status(400).json({ message: "The query parameter 'serviceId' is required." });
    }

    const data = await FTTHSpecificData.findOne({ "service.id": serviceId });

    if (!data) {
      return res.status(404).json({ message: "No FTTH data found for the provided serviceId." });
    }

    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Internal Server Error", error: err.message });
  }
};