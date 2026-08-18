const dashboardService = require('../services/dashboardService');

exports.getExtraGBDashboard = async (req, res) => {
  
  try {
    // Get all dashboard data (no username filter)
    const dashboardData = await dashboardService.getDashboardData({});
    
    res.status(200).json(dashboardData);
    
  } catch (error) {
    console.error('Error fetching dashboard data:', error);
    res.status(500).json({ 
      status: 500, 
      message: error.message 
    });
  }
};
