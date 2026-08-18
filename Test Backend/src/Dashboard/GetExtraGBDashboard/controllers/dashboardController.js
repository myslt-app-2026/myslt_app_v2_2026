const dashboardService =
require('../services/dashboardService');

exports.getExtraGBDashboard =
async (req,res) => {

    try {
        
        const data =
        await dashboardService
        .getExtraGBDashboard();

        res.status(200).json(data);

    }
    catch(error){

        res.status(500).json({

            "@type":"Error",

            code:"500",

            reason:error.message

        });

    }

};