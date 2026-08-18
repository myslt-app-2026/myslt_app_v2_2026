const UsageSummary = require('../models/Dashboard');

async function getDashboardData(filters) {
  try {
    return await UsageSummary.find(filters).lean();
  } catch (error) {
    throw error;
  }
}

module.exports = { 
  getDashboardData 
};
