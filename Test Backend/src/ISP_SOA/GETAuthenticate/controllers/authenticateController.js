const {
  authenticate
} = require("../services/authenticateService");

const authenticateRequest = async (req, res) => {

  try {

    const result = await authenticate(req.query);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error(error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = {
  authenticateRequest
};