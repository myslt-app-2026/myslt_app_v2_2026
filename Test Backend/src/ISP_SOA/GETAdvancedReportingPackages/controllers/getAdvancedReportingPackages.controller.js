const ProductOffering = require("../../../../src/models/TMF620_ProductOffering");

exports.getAdvancedReportingPackages = async (req, res) => {

    try {

        const packages = await ProductOffering.find({

            category: "AdvancedReporting",

            lifecycleStatus: "Active"

        });

        return res.status(200).json(packages);

    } catch (error) {

        return res.status(500).json({
            message: error.message
        });

    }

};