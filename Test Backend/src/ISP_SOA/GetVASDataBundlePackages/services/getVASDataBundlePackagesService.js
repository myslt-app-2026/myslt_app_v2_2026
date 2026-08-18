const ProductOffering =
require("../../../models/TMF620_ProductOffering");

const getVASDataBundlePackages = async () => {

    const packages =
    await ProductOffering.find({});

    return packages;
};

module.exports = {
    getVASDataBundlePackages
};