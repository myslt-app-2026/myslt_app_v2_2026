const { getEnhancedCurrentDailyUsage } = require('../services/enhancedCurrentDailyUsageService');

const enhancedCurrentDailyUsageRequest = async (req, res) => {
  try {
    const subscriberid = req.headers['subscriberid'];
    const billdate = req.query.billdate || '10';
    const result = await getEnhancedCurrentDailyUsage(subscriberid, billdate);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('EnhancedCurrentDailyUsage error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { enhancedCurrentDailyUsageRequest };