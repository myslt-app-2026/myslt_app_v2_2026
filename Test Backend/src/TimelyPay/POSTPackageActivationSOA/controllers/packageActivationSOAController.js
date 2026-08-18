const {
  packageActivationSOA,
} = require("../services/packageActivationSOAService");

const packageActivationSOARequest = async (req, res) => {
  try {
    console.log("Request Body:", req.body);

    const result = await packageActivationSOA(req.body);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("PackageActivationSOA Error:", error);

    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: error.message,
      error: error,
    });
  }
};

module.exports = {
  packageActivationSOARequest,
};