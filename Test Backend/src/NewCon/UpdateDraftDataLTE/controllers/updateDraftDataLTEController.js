const { updateDraftDataLTE } = require('../services/updateDraftDataLTEService');

const updateDraftDataLTERequest = async (req, res) => {
  try {
    const result = await updateDraftDataLTE(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('UpdateDraftDataLTE error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { updateDraftDataLTERequest };
