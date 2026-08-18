const { getDraftDataV2 } = require('../services/getDraftDataV2Service');

const getDraftDataV2Request = async (req, res) => {
  try {
    const result = await getDraftDataV2(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetDraftDataV2 error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getDraftDataV2Request };
