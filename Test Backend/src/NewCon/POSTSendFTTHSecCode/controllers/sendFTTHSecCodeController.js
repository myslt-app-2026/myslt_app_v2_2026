const { sendFTTHSecCode } = require('../services/sendFTTHSecCodeService');

const sendFTTHSecCodeRequest = async (req, res) => {
  try {
    const result = await sendFTTHSecCode(req.body || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('SendFTTHSecCode error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { sendFTTHSecCodeRequest };
