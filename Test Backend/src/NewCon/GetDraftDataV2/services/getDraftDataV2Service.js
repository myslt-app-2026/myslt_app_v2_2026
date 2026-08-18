const SalesLead = require('../../../models/TMF699_SalesLead');

const getDraftDataV2 = async (query = {}) => {
  const { id, status, type } = query;

  // If a specific id is requested
  if (id) {
    const lead = await SalesLead.findOne({ id });
    if (!lead) {
      return {
        success: false,
        statusCode: 404,
        message: `Draft record not found for id: ${id}`
      };
    }
    return {
      success: true,
      statusCode: 200,
      data: lead
    };
  }

  // Build filter
  const filter = {};
  if (status) filter.status = status;
  if (type) filter.type = type;

  const leads = await SalesLead.find(filter).sort({ creationDate: -1 });

  return {
    success: true,
    statusCode: 200,
    data: leads
  };
};

module.exports = { getDraftDataV2 };
