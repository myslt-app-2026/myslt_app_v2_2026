const FaultRequestV2 = require('../models/FaultRequestV2.js'); 

exports.createTroubleTicket = async (req, res) => {
  try {
    const newTroubleTicket = new FaultRequestV2(req.body); 
    const savedTroubleTicket = await newTroubleTicket.save();
    res.status(201).json(savedTroubleTicket);
  } catch (error) {
    if (error.name === 'ValidationError') {
      console.error('Validation Error:', error.message);
      return res.status(400).json({ 
        message: 'Invalid Request Payload. Mandatory fields missing or invalid data.', 
        details: error.message 
      });
    }

    console.error('Internal Server Error:', error.message);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};
