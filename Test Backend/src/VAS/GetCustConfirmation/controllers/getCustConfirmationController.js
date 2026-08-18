const service =
require("../services/getCustConfirmationService");

exports.getCustConfirmation =
async (req,res) => {

    try {

        const data =
        await service.getCustConfirmation();

        if(!data || data.length === 0){

            return res.status(404).json({

                "@type":"Error",

                code:"404",

                reason:"No Customer Confirmations Found"

            });

        }

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