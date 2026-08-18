const mongoose = require('mongoose');

const ProductOfferingPriceSchema = new mongoose.Schema({
    name: String,
    priceType: String,
    price: {
        amount: Number,
        unit: String
    },
    validFor: Object
}, { _id: false });

const ProductOfferingSchema = new mongoose.Schema({
    _id: String,
    name: String,
    productOfferingPrice: [ProductOfferingPriceSchema]
}, { collection: 'productOfferings', strict: false });

const ProductOffering = mongoose.models.ProductOfferingTMF || mongoose.model('ProductOfferingTMF', ProductOfferingSchema);

class ProductOfferingPriceService {

    static async listPrices(filters) {
        let query = { "productOfferingPrice.0": { $exists: true } };

        const postFilters = { ...filters };

        if (postFilters.offeringType) {
            query.offeringType = postFilters.offeringType;
            delete postFilters.offeringType;
        }

        const offerings = await ProductOffering.find(query).lean();

        if (!offerings || offerings.length === 0) {
            return [];
        }

        let allPrices = offerings.flatMap(offering => {
            if (!offering.productOfferingPrice) return [];

            return offering.productOfferingPrice.map((price, index) => {
                const priceTypeSuffix = price.priceType ? price.priceType.toUpperCase() : 'PRICE';
                const priceId = `${offering._id}-POP-${priceTypeSuffix}-${index + 1}`;

                return {
                    id: priceId,
                    href: `/tmf-api/productCatalogManagement/v4/productOfferingPrice/${priceId}`,
                    name: price.name || `${offering.name} - ${price.priceType} Charge`,
                    description: price.description || `${price.priceType} charge for ${offering.name}`,
                    "@type": "ProductOfferingPrice",
                    priceType: price.priceType,
                    price: {
                        "@type": "Money",
                        taxIncludedAmount: {
                            unit: price.price?.unit || "USD",
                            value: price.price?.amount || 0
                        },
                        dutyFreeAmount: {
                            unit: price.price?.unit || "USD",
                            value: price.price?.amount || 0
                        }
                    },
                    lifecycleStatus: "Active",
                    productOffering: {
                        id: offering._id,
                        name: offering.name,
                        "@referredType": "ProductOffering"
                    },
                    validFor: price.validFor,
                    lastUpdate: new Date().toISOString()
                };
            });
        });

        if (postFilters && Object.keys(postFilters).length > 0) {
            allPrices = allPrices.filter(priceItem => {
                return Object.keys(postFilters).every(key => {
                    if (key.includes('.')) {
                        const [parent, child] = key.split('.');
                        return priceItem[parent] && priceItem[parent][child] == postFilters[key];
                    }
                    return priceItem[key] == postFilters[key];
                });
            });
        }

        return allPrices;
    }

    static async getPriceById(id) {
        const prices = await this.listPrices();
        return prices.find(p => p.id === id);
    }
}

module.exports = ProductOfferingPriceService;
