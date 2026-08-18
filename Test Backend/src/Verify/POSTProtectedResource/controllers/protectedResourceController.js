const { getProtectedResource } = require("../services/protectedResourceService");

const protectedResourceRequest = async (req, res) => {

  try {

    const result = await getProtectedResource(req.user);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error("POSTProtectedResource error:", error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

module.exports = { protectedResourceRequest };