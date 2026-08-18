const service =
require("../services/getPurchaseHistoryService");

exports.getPurchaseHistory =
async (req, res) => {

  
    try {

        const { from, to } = req.query;

        const result =
        await service.getPurchaseHistory(from, to);

        res.status(200).json({

            "@type": "PurchaseHistory",

            count: result.length,

            data: result

        });

    }
    catch (error) {

        res.status(500).json({

            "@type": "Error",

            code: "500",

            reason: error.message

        });

    }

};