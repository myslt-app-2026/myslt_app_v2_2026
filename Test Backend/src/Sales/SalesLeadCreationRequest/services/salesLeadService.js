const SalesLead = require('../../../models/TMF699_SalesLead');

async function createSalesLead(data) {
  const salesLead = new SalesLead(data);
  return await salesLead.save();
}

module.exports = { createSalesLead };
