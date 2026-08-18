const getVASBundlePackages = async (basepackage, subscriberid) => {
  return {
    id: `VAS-PACKAGES-${Date.now()}`,
    href: `/tmf-api/productCatalogManagement/v4/productOffering?category=vasDataBundle&basepackage=${basepackage || ""}`,
    name: "VAS Data Bundle Packages",
    description: "Available VAS data bundle packages for ISP Direct subscriber",
    lifecycleStatus: "Launched",
    category: [
      {
        id: "VAS_DATA_BUNDLE",
        name: "VAS Data Bundle",
        "@type": "CategoryRef",
      },
    ],
    productOffering: [
      {
        id: "VAS-DATA-1GB",
        name: "VAS Data Bundle 1GB",
        description: "1GB VAS data bundle package",
        lifecycleStatus: "Launched",
        isSellable: true,
        productOfferingPrice: [
          {
            id: "PRICE-1GB",
            name: "VAS Data 1GB Price",
            priceType: "recurring",
            price: {
              taxIncludedAmount: {
                unit: "LKR",
                value: 100,
              },
            },
            "@type": "ProductOfferingPriceRefOrValue",
          },
        ],
        productSpecification: {
          id: "SPEC-VAS-DATA-1GB",
          name: "VAS Data Bundle 1GB Specification",
          "@type": "ProductSpecificationRef",
        },
        "@type": "ProductOffering",
      },
      {
        id: "VAS-DATA-5GB",
        name: "VAS Data Bundle 5GB",
        description: "5GB VAS data bundle package",
        lifecycleStatus: "Launched",
        isSellable: true,
        productOfferingPrice: [
          {
            id: "PRICE-5GB",
            name: "VAS Data 5GB Price",
            priceType: "recurring",
            price: {
              taxIncludedAmount: {
                unit: "LKR",
                value: 450,
              },
            },
            "@type": "ProductOfferingPriceRefOrValue",
          },
        ],
        productSpecification: {
          id: "SPEC-VAS-DATA-5GB",
          name: "VAS Data Bundle 5GB Specification",
          "@type": "ProductSpecificationRef",
        },
        "@type": "ProductOffering",
      },
    ],
    relatedParty: [
      {
        id: subscriberid,
        role: "subscriber",
        "@type": "RelatedParty",
      },
    ],
    "@type": "ProductOfferingCatalog",
  };
};

module.exports = {
  getVASBundlePackages,
};