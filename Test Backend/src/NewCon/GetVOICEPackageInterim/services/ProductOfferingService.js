/**
 * ProductOfferingService - TMF620 Product Catalog Management (VOICE Interim)
 * Queries productOfferings collection with optional Mode filter.
 * When Mode provided: filter by productSpecification.accessType
 */
const ProductOffering = require('../../../models/TMF620_ProductOffering');

const BASE_PATH = '/tmf-api/productCatalogManagement/v4/GetVOICEPackageInterim';

class ProductOfferingService {
  /**
   * List product offerings with optional Mode filter
   * @param {Object} queryParams - { Mode?: string }
   * @returns {Array} TMF620 ProductOffering objects
   */
  static async listProductOfferings(queryParams = {}) {
    const { Mode } = queryParams;

    const mongoQuery = { lifecycleStatus: 'Active' };

    if (Mode && typeof Mode === 'string' && Mode.trim()) {
      mongoQuery['productSpecification.accessType'] = Mode.trim();
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
