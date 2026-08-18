const { getMyPackage } = require('../services/getMyPackageService');

const getMyPackageRequest = async (req, res) => {
  try {
    const result = await getMyPackage(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('[GETMyPackage] Error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getMyPackageRequest };
