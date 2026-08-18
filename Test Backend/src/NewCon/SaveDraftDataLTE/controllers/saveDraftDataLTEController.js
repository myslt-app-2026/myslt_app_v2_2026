const { saveDraftDataLTE } = require('../services/saveDraftDataLTEService');

const saveDraftDataLTERequest = async (req, res) => {
  try {
    const result = await saveDraftDataLTE(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('SaveDraftDataLTE error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { saveDraftDataLTERequest };
