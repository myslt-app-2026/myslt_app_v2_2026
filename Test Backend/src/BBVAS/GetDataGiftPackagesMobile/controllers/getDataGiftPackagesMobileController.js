const asyncHandler = require('express-async-handler');
const DataGiftPackage = require('../../../models/TMF620_ProductOffering');

const getDataGiftPackagesMobile = asyncHandler(async (req, res) => {
  try {
    const dataGiftPackages = await DataGiftPackage.find({});
    res.status(200).json(dataGiftPackages);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = {
  getDataGiftPackagesMobile,
};