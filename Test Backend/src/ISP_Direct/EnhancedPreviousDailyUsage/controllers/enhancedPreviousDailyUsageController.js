const { getEnhancedPreviousDailyUsage } = require('../services/enhancedPreviousDailyUsageService');

const enhancedPreviousDailyUsageRequest = async (req, res) => {
  try {
    const subscriberid = req.headers['subscriberid'];
    const billdate = req.query.billdate || '01';
    const result = await getEnhancedPreviousDailyUsage(subscriberid, billdate);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('EnhancedPreviousDailyUsage error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { enhancedPreviousDailyUsageRequest };