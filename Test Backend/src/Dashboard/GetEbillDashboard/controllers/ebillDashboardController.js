const {
  getEbillDashboard
} = require("../services/ebillDashboardService");

const getEbillDashboardRequest =
async (req, res) => {

  try {

    const result =
      await getEbillDashboard(req.query);

    return res
      .status(result.statusCode)
      .json(result);

  } catch (error) {

    console.error(
      "GetEbillDashboard Error:",
      error
    );

    return res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });

  }

};

module.exports = {
  getEbillDashboardRequest
};