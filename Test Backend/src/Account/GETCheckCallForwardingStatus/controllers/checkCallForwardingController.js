const { checkCallForwardingStatus } = require('../services/checkCallForwardingService');

const checkCallForwardingRequest = async (req, res) => {
  try {
    const result = await checkCallForwardingStatus(req.query || {}, req.headers['authorization']);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GETCheckCallForwardingStatus error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { checkCallForwardingRequest };