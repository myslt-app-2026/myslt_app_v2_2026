const subtokenService = require("../services/subtokenService");

exports.getSubscriberToken = async (req, res) => {

    try {

        const result = await subtokenService.getSubscriberToken();

        if (!result) {
            return res.status(404).json({
                code: "404",
                message: "Subscriber token not found"
            });
        }

        return res.status(200).json({
            code: "200",
            message: "Success",
            data: result
        });

    } catch (error) {

        return res.status(500).json({
            code: "500",
            message: error.message
        });

    }
};