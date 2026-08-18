const { getDashboardVASBundles } = require('../services/getDashboardVASBundlesService');

const getDashboardVASBundlesRequest = async (req, res) => {
  try {
    const result = await getDashboardVASBundles(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('[GETDashboardVASBundles] Error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getDashboardVASBundlesRequest };
