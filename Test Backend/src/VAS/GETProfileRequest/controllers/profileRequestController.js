const { getProfileRequest } = require("../services/profileRequestService");

const profileRequestController = async (req, res) => {

  try {

    const result = await getProfileRequest(req.query);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error("GETProfileRequest error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { profileRequestController };