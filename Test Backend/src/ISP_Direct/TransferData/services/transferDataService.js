const ProductOrder =
require("../../../models/TMF622_ProductOrder");

const transferData = async (body) => {

    const transferOrder =
    new ProductOrder({

        id: "TR" + Date.now(),

        description: "Data Transfer",

        state: "acknowledged",

        relatedParty: [
            {
                id: body.sender,
                role: "sender"
            },
            {
                id: body.receiver,
                role: "receiver"
            }
        ]
    });

    await transferOrder.save();

    return transferOrder;
};

module.exports = {
    transferData
};