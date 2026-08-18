const UsageManagement =
require("../../../models/TMF635_UsageManagement");

const transferData = async (body) => {

    return {

        transferFrom: body.transferFrom,
        transferTo: body.transferTo,
        amount: body.amount,
        unit: "GB",
        status: "completed",
        "@type": "TransferData"

    };

};

module.exports = {
    transferData
};