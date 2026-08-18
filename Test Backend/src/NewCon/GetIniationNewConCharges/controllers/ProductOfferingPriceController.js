const ProductOfferingPriceService = require('../services/ProductOfferingPriceService');

class ProductOfferingPriceController {

    static async listProductOfferingPrices(req, res) {
        try {
            const prices = await ProductOfferingPriceService.listPrices(req.query);
            res.status(200).json(prices);
        } catch (error) {
            res.status(500).json({
                code: "500",
                reason: "Internal Server Error",
                message: error.message,
                status: "500",
                referenceError: "https://api.yourcompany.com/errors/500"
            });
        }
    }

    static async retrieveProductOfferingPrice(req, res) {
        try {
            const price = await ProductOfferingPriceService.getPriceById(req.params.id);

            if (!price) {
                return res.status(404).json({
                    code: "404",
                    reason: "Not Found",
                    message: "ProductOfferingPrice not found",
                    status: "404",
                    referenceError: "https://api.yourcompany.com/errors/404"
                });
            }

            res.status(200).json(price);
        } catch (error) {
            res.status(500).json({
                code: "500",
                reason: "Internal Server Error",
                message: error.message,
                status: "500",
                referenceError: "https://api.yourcompany.com/errors/500"
            });
        }
    }
}

module.exports = ProductOfferingPriceController;
