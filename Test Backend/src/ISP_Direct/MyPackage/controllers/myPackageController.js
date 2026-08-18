const { getMyPackage } = require('../services/myPackageService');

const myPackageRequest = async (req, res) => {
  try {
    const subscriberid = req.headers['subscriberid'];
    const result = await getMyPackage(subscriberid);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('MyPackage error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { myPackageRequest };