const purchaseHistoryService =
require("../services/purchaseHistoryService");

exports.getPurchaseHistory = async (req, res) => {

    try {

        const { from, to } = req.query;

        const result =
        await purchaseHistoryService.getPurchaseHistory(from, to);

        return res.status(200).json({
            code: "200",
            message: "Success",
            count: result.length,
            data: result
        });

    } catch (error) {

        return res.status(500).json({
            code: "500",
            message: error.message
        });

    }
};