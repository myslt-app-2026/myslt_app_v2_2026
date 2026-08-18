const ProductOffering = require("../../../models/TMF620_ProductOffering");

async function getVASDataBundlePackages() {
  const packages = await ProductOffering.find({
    $or: [
      { category: { $regex: /vas/i } },
      { offeringType: { $regex: /vas/i } },
      { name: { $regex: /vas/i } }
    ],
    lifecycleStatus: "Active"
  });

  if (packages.length === 0) {
    return [
      {
        id: "VAS-2GB-7D",
        name: "VAS Data Bundle 2GB",
        category: "VAS",
        offeringType: "VAS",
        lifecycleStatus: "Active",
        description: "VAS Data Bundle 2GB for 7 Days",
        "@type": "ProductOffering"
      },
      {
        id: "VAS-5GB-30D",
        name: "VAS Data Bundle 5GB",
        category: "VAS",
        offeringType: "VAS",
        lifecycleStatus: "Active",
        description: "VAS Data Bundle 5GB for 30 Days",
        "@type": "ProductOffering"
      }
    ];
  }

  return packages;
}

module.exports = { getVASDataBundlePackages };