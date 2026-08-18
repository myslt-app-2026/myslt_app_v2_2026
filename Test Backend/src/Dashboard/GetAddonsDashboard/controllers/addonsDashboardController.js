const {
  getAddonsDashboard
} = require("../services/addonsDashboardService");

const getAddonsDashboardRequest =
async (req, res) => {

   

  try {

    const result =
      await getAddonsDashboard();

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error(
      "GetAddonsDashboard Error:",
      error
    );

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });

  }

};

module.exports = {
  getAddonsDashboardRequest
};