const { checkCRMLeadStatus } = require('../services/checkCRMLeadStatusService');

const checkCRMLeadStatusRequest = async (req, res) => {
  try {
    const result = await checkCRMLeadStatus(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('CheckCRMLeadStatus error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { checkCRMLeadStatusRequest };
