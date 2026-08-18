const { getBonusData } = require('../services/getBonusDataService');

const getBonusDataRequest = async (req, res) => {
  try {
    const result = await getBonusData(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('[GETBonusData] Error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getBonusDataRequest };
