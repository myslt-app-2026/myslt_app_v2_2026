const ProductOrder =
require("../../../models/TMF622_ProductOrder");

const unsubscribeBundle = async (id) => {

    const result =
    await ProductOrder.findOneAndUpdate(

        {
            id: id
        },

        {
            state: "cancelled"
        },

        {
            new: true
        }

    );

    return result;

};

module.exports = {
    unsubscribeBundle
};