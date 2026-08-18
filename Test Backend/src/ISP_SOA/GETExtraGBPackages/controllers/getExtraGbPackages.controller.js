const ProductOffering = require("../../../../src/models/TMF620_ProductOffering");

exports.getExtraGbPackages = async (req, res) => {

    try {

        const { basepackage } = req.query;

        const packages = await ProductOffering.find({
            category: "ExtraGB",
            lifecycleStatus: "Active",
            "productSpecification.id": basepackage
        });

        return res.status(200).json(packages);

    } catch (error) {

        return res.status(500).json({
            message: error.message
        });

    }

};