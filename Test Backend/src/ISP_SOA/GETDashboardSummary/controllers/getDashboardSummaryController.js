const { getDashboardSummary } = require('../services/getDashboardSummaryService');

const getDashboardSummaryRequest = async (req, res) => {
  try {
    const result = await getDashboardSummary(req.query);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GETDashboardSummary error:', error.message);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error',
      error: error.message
    });
  }
};

module.exports = { getDashboardSummaryRequest };