const { getFreeData } = require('../services/getFreeDataService');

const getFreeDataRequest = async (req, res) => {
  try {
    const result = await getFreeData(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('[GETFreeData] Error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getFreeDataRequest };
