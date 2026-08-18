const productInventoryService = require("./productInventoryService");

class ProductInventoryController {

  async getProduct(req, res) {
    const { publicIdentifier, productOfferingName } = req.query;

    if (!publicIdentifier || !productOfferingName) {
      return res.status(400).json({
        error: "publicIdentifier and productOfferingName are required"
      });
    }

    const product = await productInventoryService
      .findActivePEOVASByTelephone(publicIdentifier);

    if (!product) {
      return res.status(404).json([]);
    }

    return res.status(200).json([product]);
  }

}

module.exports = new ProductInventoryController();
