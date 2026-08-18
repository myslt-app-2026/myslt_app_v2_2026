const { getUserInfo } = require('../services/getUserInfoService');

const getUserInfoRequest = async (req, res) => {
  try {
    const result = await getUserInfo(req.query || {}, req.headers['authorization']);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetUserInfo error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { getUserInfoRequest };