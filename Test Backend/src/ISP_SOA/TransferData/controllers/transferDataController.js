const service =
require("../services/transferDataService");

exports.transferData = async (req, res) => {

    try {

        const result =
        await service.transferData(req.body);

        res.status(200).json(result);

    }
    catch(error){

        res.status(500).json({

            "@type":"Error",
            code:"500",
            reason:error.message

        });

    }

};