const advancedReportingPackageService = require('../services/advancedReportingPackage.service');

exports.getAdvancedReportingPackages = async (req, res) => {
  try {
    const data = await advancedReportingPackageService.getAllPackages();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAdvancedReportingPackageById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await advancedReportingPackageService.getPackageById(id);
    if (!data) {
      return res.status(404).json({ error: 'AdvancedReportingPackage not found' });
    }
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
