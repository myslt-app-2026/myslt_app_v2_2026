const {
  validateDataTransferSub
} = require("../services/validateDataTransferSubService");

const validateDataTransferSubRequest = async (req, res) => {

  try {

    const result = await validateDataTransferSub(req.query);

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
  validateDataTransferSubRequest
};