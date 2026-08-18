const { changeBBPassword } = require("../services/customerService");

const changeBBPasswordController = async (req, res) => {
  try {
    const result = await changeBBPassword(req.body);
    return res.status(result.statusCode).json(result);
  } catch (error) {
    console.error("ChangeBBPassword error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

module.exports = { changeBBPasswordController };