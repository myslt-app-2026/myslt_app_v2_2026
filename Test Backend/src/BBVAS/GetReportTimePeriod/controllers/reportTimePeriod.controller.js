const reportTimePeriodService = require('../services/reportTimePeriod.service');

exports.getReportTimePeriods = async (req, res) => {
  try {
    const data = await reportTimePeriodService.getAllReportTimePeriods();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getReportTimePeriodById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = await reportTimePeriodService.getReportTimePeriodById(id);
    if (!data) {
      return res.status(404).json({ error: 'ReportTimePeriod not found' });
    }
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
