const dashboardService =
require("../services/dashboardService");

exports.getFTTHNCDashboard =
async (req,res)=>{

  try{

    const result =
      await dashboardService.getDashboardData();

    res.status(200).json(result);

  }
  catch(error){

    res.status(500).json({
      message:error.message
    });

  }
};