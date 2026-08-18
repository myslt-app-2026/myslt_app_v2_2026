const { getFaultDashboard } = require('../services/getFaultDashboardService');

const getFaultDashboardRequest = async (req, res) => {
  try {
    const result = await getFaultDashboard(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetFaultDashboard error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getFaultDashboardRequest };
