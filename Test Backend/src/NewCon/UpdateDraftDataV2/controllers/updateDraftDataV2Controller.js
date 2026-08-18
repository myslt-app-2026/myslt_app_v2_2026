const { updateDraftDataV2 } = require('../services/updateDraftDataV2Service');

const updateDraftDataV2Request = async (req, res) => {
  try {
    const result = await updateDraftDataV2(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('UpdateDraftDataV2 error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { updateDraftDataV2Request };
