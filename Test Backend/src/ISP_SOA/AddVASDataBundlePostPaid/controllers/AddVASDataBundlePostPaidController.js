const service =
require("../services/addVASDataBundlePostPaidService");

exports.addVASDataBundlePostPaid =
async (req,res)=>{

    try{

        const result =
        await service
        .addVASDataBundlePostPaid(req.body);

        res.status(201).json(result);

    }
    catch(error){

        res.status(500).json({

            "@type":"Error",

            code:"500",

            reason:error.message

        });

    }

};