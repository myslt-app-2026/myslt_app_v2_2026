const service =
require("../services/purchaseAdvancedReportsService");

exports.purchaseAdvancedReportsPostPaid =
async (req,res)=>{

    try{

        const data =
        await service
        .purchaseAdvancedReportsPostPaid(
            req.body
        );

        res.status(201).json(data);

    }
    catch(error){

        res.status(500).json({
            "@type":"Error",
            code:"500",
            reason:error.message
        });

    }

};