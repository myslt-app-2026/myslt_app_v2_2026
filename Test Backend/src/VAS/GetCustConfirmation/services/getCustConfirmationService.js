const ProductOrder =
require("../../../models/TMF622_ProductOrder");

const getCustConfirmation = async () => {

    try {

        const confirmations =
        await ProductOrder.find().limit(20);

        return confirmations;

    }
    catch(error){

        throw error;

    }

};

module.exports = {
    getCustConfirmation
};