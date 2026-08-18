const service =
require("../services/transferDataService");

exports.transferData =
async (req, res) => {

    try {

        const data =
        await service.transferData(
            req.body
        );

        res.status(201).json(data);

    }
    catch (error) {

        res.status(500).json({

            "@type": "Error",

            code: "500",

            reason: error.message

        });

    }

};