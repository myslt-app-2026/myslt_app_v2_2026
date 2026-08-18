const service =
require("../services/getDashboardVASBundlesService");

exports.getDashboardVASBundles =
async (req,res) => {

    try {

        const bundles =
        await service.getDashboardVASBundles();

        if(!bundles || bundles.length === 0){

            return res.status(404).json({

                "@type":"Error",

                code:"404",

                reason:"No VAS Bundles Found"

            });

        }

        res.status(200).json(bundles);

    }
    catch(error){

        res.status(500).json({

            "@type":"Error",

            code:"500",

            reason:error.message

        });

    }

};