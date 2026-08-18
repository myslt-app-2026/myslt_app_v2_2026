const TMF620_ProductCatalog = require("../../../models/TMF620_ProductOffering");

const getVOICEPackageInterim = async (query) => {
  const { accountNo } = query;

  if (!accountNo) {
    return {
      success: false,
      statusCode: 400,
      message: "accountNo is required",
    };
  }

  const packages = await TMF620_ProductCatalog.find({
    category: "VOICE",
  });

  return {
    success: true,
    statusCode: 200,
    message: "Voice packages retrieved successfully",
    data: packages,
  };
};

module.exports = { getVOICEPackageInterim };