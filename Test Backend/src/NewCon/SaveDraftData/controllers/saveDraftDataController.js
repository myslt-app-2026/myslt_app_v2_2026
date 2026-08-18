const { saveDraftData } = require('../services/saveDraftDataService');

const saveDraftDataRequest = async (req, res) => {
  try {
    const result = await saveDraftData(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('SaveDraftData error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { saveDraftDataRequest };
