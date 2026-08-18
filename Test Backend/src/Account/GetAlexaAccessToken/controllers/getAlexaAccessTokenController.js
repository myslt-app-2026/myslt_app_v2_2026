const { getAlexaAccessToken } = require('../services/getAlexaAccessTokenService');

const getAlexaAccessTokenRequest = async (req, res) => {
  try {
    const result = await getAlexaAccessToken(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetAlexaAccessToken error:', error.message);
    return res.status(500).json({ success: false, message: 'Internal Server Error', error: error.message });
  }
};

module.exports = { getAlexaAccessTokenRequest };