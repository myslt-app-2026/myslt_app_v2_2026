const { getOrderStatus } = require('../services/getOrderStatusService');

const getOrderStatusRequest = async (req, res) => {
  try {
    const result = await getOrderStatus(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetOrderStatus error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getOrderStatusRequest };
