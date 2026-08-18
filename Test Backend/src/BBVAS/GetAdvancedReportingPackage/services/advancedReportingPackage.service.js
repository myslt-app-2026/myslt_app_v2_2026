const AdvancedReportingPackage = require('../models/advancedReportingPackage.model');

async function getAllPackages() {
  return await AdvancedReportingPackage.find();
}

async function getPackageById(id) {
  return await AdvancedReportingPackage.findOne({ id });
}

module.exports = {
  getAllPackages,
  getPackageById
};
