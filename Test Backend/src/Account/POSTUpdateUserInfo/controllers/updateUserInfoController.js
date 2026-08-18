const { updateUserInfo } = require("../services/updateUserInfoService");

const updateUserInfoRequest = async (req, res) => {

  try {

    const result = await updateUserInfo(req.body);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error("UpdateUserInfo error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { updateUserInfoRequest };