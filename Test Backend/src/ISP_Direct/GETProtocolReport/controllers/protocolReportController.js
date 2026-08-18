const protocolReportService =
require("../services/protocolReportService");

exports.getProtocolReport = async (req, res) => {

    try {

        const result =
        await protocolReportService.getProtocolReport(req.query);

        return res
            .status(result.statusCode)
            .json(result);

    }
    catch (error) {

        return res.status(500).json({

            success: false,
            statusCode: 500,
            message: error.message

        });

    }

};