const { updateUserInfo } = require('../services/updateUserInfoService');

const updateUserInfoRequest = async (req, res) => {
  try {
    const result = await updateUserInfo(req.body || {}, req.headers['authorization']);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('UpdateUserInfo error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { updateUserInfoRequest };