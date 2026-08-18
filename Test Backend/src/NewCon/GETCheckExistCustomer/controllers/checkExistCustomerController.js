const {
  checkExistCustomer,
} = require("../services/checkExistCustomerService");

const checkExistCustomerRequest = async (req, res) => {
  try {
    const result = await checkExistCustomer(req.query);

    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("CheckExistCustomer error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { checkExistCustomerRequest };