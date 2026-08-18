const CustomerBillManagement =
require("../../../models/TMF678_CustomerBillManagement");

const getPurchaseHistory = async (from, to) => {

    const query = {};

    if (from && to) {

        query.createdAt = {
            $gte: new Date(from),
            $lte: new Date(to)
        };

    }

    return await CustomerBillManagement.find(query);

};

module.exports = {
    getPurchaseHistory
};