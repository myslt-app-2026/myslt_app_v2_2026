const ReportTimePeriod = require('../models/reportTimePeriod.model');

async function getAllReportTimePeriods() {
  return await ReportTimePeriod.find();
}

async function getReportTimePeriodById(id) {
  return await ReportTimePeriod.findOne({ id });
}

module.exports = {
  getAllReportTimePeriods,
  getReportTimePeriodById
};
