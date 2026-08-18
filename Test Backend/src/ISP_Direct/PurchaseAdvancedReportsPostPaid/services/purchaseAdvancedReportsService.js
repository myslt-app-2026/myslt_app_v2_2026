const ProductOrder =
require("../../../models/TMF622_ProductOrder");

const purchaseAdvancedReportsPostPaid =
async (body) => {

    const order =
    new ProductOrder({

        id: "APR" + Date.now(),

        description:
        body.description,

        state: "acknowledged",

        productOrderItem: [
            {
                id: "ITEM1",
                action: "add",
                quantity: 1
            }
        ]
    });

    await order.save();

    return order;
};

module.exports = {
    purchaseAdvancedReportsPostPaid
};