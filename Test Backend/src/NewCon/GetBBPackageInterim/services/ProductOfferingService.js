/**
 * ProductOfferingService - TMF620 Product Catalog Management
 * Queries productOfferings collection with optional accessType filter.
 * When accessType provided: filter by productSpecification.accessType
 * When no accessType: return all active offerings
 */
const ProductOffering = require('../models/ProductOffering.model');

const BASE_PATH = '/tmf-api/productCatalogManagement/v4/productOffering';

class ProductOfferingService {
  /**
   * List product offerings with optional accessType filter
   * @param {Object} queryParams - { accessType?: string }
   * @returns {Array} TMF620 ProductOffering objects
   */
  static async listProductOfferings(queryParams = {}) {
    const { accessType } = queryParams;

    const mongoQuery = { lifecycleStatus: 'Active' };

    if (accessType && typeof accessType === 'string' && accessType.trim()) {
      mongoQuery['productSpecification.accessType'] = accessType.trim();
    }

    const offerings = await ProductOffering.find(mongoQuery).lean();

    return offerings.map((doc) => ProductOfferingService._toTMF620ProductOffering(doc));
  }

  /**
   * Map MongoDB document to TMF620 ProductOffering schema
   */
  static _toTMF620ProductOffering(doc) {
    const id = String(doc._id || doc.id || '');
    const productSpec = doc.productSpecification || {};
    const specId = productSpec.id || productSpec._id || id;

    return {
      id,
      href: `${BASE_PATH}/${id}`,
      name: doc.name || '',
      description: doc.description || '',
      lifecycleStatus: doc.lifecycleStatus || 'Active',
      productSpecification: {
        id: String(specId),
        href: `/tmf-api/productCatalogManagement/v4/productSpecification/${specId}`,
        '@referredType': 'ProductSpecification'
      },
      '@type': 'ProductOffering'
    };
  }
}

module.exports = ProductOfferingService;
