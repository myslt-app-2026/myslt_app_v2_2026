const ProductOrder =
require("../../../models/TMF622_ProductOrder");

const addVASDataBundlePostPaid = async (body) => {

    const orderId =
    "PO" + Date.now();

    const order =
    new ProductOrder({

        id: orderId,

        description:
        body.description,

        state: "acknowledged",

        productOrderItem: [

            {

                id: "ITEM1",

                action: "add",

                quantity: 1,

                productOffering: {

                    id: body.packageId,

                    name: body.packageName

                }

            }

        ]

    });

    await order.save();

    return order;
};

module.exports = {
    addVASDataBundlePostPaid
};