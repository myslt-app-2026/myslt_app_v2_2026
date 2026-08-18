const { getAgentCode } = require('../services/getAgentCodeService');

const getAgentCodeRequest = async (req, res) => {
  try {
    const result = await getAgentCode(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetAgentCode error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getAgentCodeRequest };
