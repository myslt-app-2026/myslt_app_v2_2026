const ProductOffering =
require("../../../models/TMF620_ProductOffering");

const getDashboardVASBundles = async () => {

    try {

        const bundles =
        await ProductOffering.find({

            lifecycleStatus: "Active"

        });

        return bundles;

    }
    catch(error){

        throw error;

    }

};

module.exports = {
    getDashboardVASBundles
};