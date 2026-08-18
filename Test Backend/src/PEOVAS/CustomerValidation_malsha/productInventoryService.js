const Product = require("../../../src/models/TMF637_Product.js");

class ProductInventoryService {

  async findActivePEOVASByTelephone(telephoneNo) {
    return Product.findOne({
      publicIdentifier: telephoneNo,
      "productOffering.name": "PEOVAS",
      status: "active"
    }).lean();
  }

}

module.exports = new ProductInventoryService();
