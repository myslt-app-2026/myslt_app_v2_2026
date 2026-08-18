const { updateAgentCode } = require('../services/updateAgentCodeService');

const updateAgentCodeRequest = async (req, res) => {
  try {
    const result = await updateAgentCode(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('UpdateAgentCode error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { updateAgentCodeRequest };
