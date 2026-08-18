const { getSelectLOV } = require('../services/getSelectLOVService');

const getSelectLOVRequest = async (req, res) => {
  try {
    const result = await getSelectLOV(req.query || {});
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error('GetSelectLOV error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal Server Error'
    });
  }
};

module.exports = { getSelectLOVRequest };
