const service =
require("../services/vasBundleUnsubscriptionService");

exports.unsubscribeBundle =
async (req, res) => {

    try {

        const result =
        await service.unsubscribeBundle(
            req.params.id
        );

        if (!result) {

            return res.status(404).json({

                "@type": "Error",
                code: "404",
                reason: "Bundle not found"

            });

        }

        res.status(200).json(result);

    }
    catch (error) {

        res.status(500).json({

            "@type": "Error",
            code: "500",
            reason: error.message

        });

    }

};