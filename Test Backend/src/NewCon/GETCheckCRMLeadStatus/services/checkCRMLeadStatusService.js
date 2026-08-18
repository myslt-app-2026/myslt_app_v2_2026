/**
 * checkCRMLeadStatusService
 * Checks the CRM lead status for a new connection request
 * Uses TMF699 SalesLead model - the lead status tracks CRM workflow
 *
 * CRM Lead status values:
 * draft → acknowledged → inProgress → won | lost | cancelled
 */
const SalesLead = require('../../../models/TMF699_SalesLead');

const checkCRMLeadStatus = async (query = {}) => {
  const { id, leadId, name, tpNo, type } = query;

  const lookupId = id || leadId;

  // Lookup by specific lead ID
  if (lookupId) {
    const lead = await SalesLead.findOne({ id: lookupId });
    if (!lead) {
      return {
        success: false,
        statusCode: 404,
        message: `CRM Lead not found for id: ${lookupId}`
      };
    }
    return {
      success: true,
      statusCode: 200,
      data: {
        id: lead.id,
        href: lead.href,
        name: lead.name,
        type: lead.type,
        status: lead.status,
        statusChangeDate: lead.statusChangeDate,
        statusChangeReason: lead.statusChangeReason,
        creationDate: lead.creationDate,
        relatedParty: lead.relatedParty,
        channel: lead.channel,
        productOffering: lead.productOffering,
        '@type': lead['@type']
      }
    };
  }

  // Filter by name, tpNo (in relatedParty.id), or type
  const filter = {};
  if (name) filter.name = { $regex: name, $options: 'i' };
  if (type) filter.type = type;
  if (tpNo) filter['relatedParty.id'] = tpNo;

  if (Object.keys(filter).length === 0) {
    return {
      success: false,
      statusCode: 400,
      message: 'Please provide at least one query param: id, leadId, name, tpNo, or type'
    };
  }

  const leads = await SalesLead.find(filter)
    .select('id href name type status statusChangeDate statusChangeReason creationDate relatedParty channel productOffering @type')
    .sort({ creationDate: -1 });

  return {
    success: true,
    statusCode: 200,
    data: leads
  };
};

module.exports = { checkCRMLeadStatus };
