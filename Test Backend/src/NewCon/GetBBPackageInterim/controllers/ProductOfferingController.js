/**
 * ProductOfferingController - TMF620 Product Catalog Management
 * GET /tmf-api/productCatalogManagement/v4/productOffering?accessType=4G
 */
const ProductOfferingService = require('../services/ProductOfferingService');

class ProductOfferingController {
  /**
   * List product offerings - TMF620 compliant
   * Query params: accessType (optional) - filters by productSpecification.accessType
   */
  static async listProductOfferings(req, res) {
    try {
      const offerings = await ProductOfferingService.listProductOfferings(req.query);
      res.status(200).json(offerings);
    } catch (error) {
      res.status(500).json({
        code: '500',
        reason: 'Internal Server Error',
        message: error.message,
        status: '500',
        referenceError: 'https://www.tmforum.org/resources/standard/tmf620-product-catalog-management-api-rest-specification/'
      });
    }
  }
}

module.exports = ProductOfferingController;
