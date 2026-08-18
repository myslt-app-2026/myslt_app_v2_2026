const { changeBBPassword } = require("../services/changeBBPasswordService");

const changeBBPasswordRequest = async (req, res) => {

  try {

    const result = await changeBBPassword(req.body);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error("ChangeBBPassword error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { changeBBPasswordRequest };