const service =
require("../services/getVoiceUsageService");

exports.getVoiceUsage =
async (req,res) => {

    try {

        const data =
        await service.getVoiceUsage();

        if(!data || data.length === 0){

            return res.status(404).json({

                "@type":"Error",

                code:"404",

                reason:"No Voice Usage Found"

            });

        }

        res.status(200).json({

            "@type":"VoiceUsage",

            totalRecords:data.length,

            usage:data

        });

    }
    catch(error){

        res.status(500).json({

            "@type":"Error",

            code:"500",

            reason:error.message

        });

    }

};