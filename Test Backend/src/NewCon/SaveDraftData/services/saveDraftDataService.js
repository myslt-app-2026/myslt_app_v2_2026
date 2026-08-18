const SalesLead = require('../../../models/TMF699_SalesLead');
const { v4: uuidv4 } = require('uuid');

const saveDraftData = async (body = {}) => {
  const {
    name,
    description,
    type,
    rating,
    priority,
    estimatedRevenue,
    validFor,
    marketSegment,
    marketingCampaign,
    channel,
    productOffering,
    product,
    category,
    salesOpportunity,
    note,
    relatedParty,
    prospectContact,
    statusChangeReason
  } = body;

  if (!name || name.trim() === '') {
    return {
      success: false,
      statusCode: 400,
      message: 'Missing mandatory attribute: name'
    };
  }

  const newId = uuidv4();
  const now = new Date();

  const draftLead = await SalesLead.create({
    id: newId,
    href: `http://127.0.0.1:3000/tmf-api/sales/v4/draftData/${newId}`,
    '@type': 'SalesLead',
    name,
    description,
    type: type || 'FTTH',
    rating,
    priority,
    estimatedRevenue,
    validFor,
    marketSegment,
    marketingCampaign,
    channel,
    productOffering,
    product,
    category,
    salesOpportunity,
    note,
    relatedParty,
    prospectContact,
    status: 'draft',
    statusChangeDate: now,
    statusChangeReason: statusChangeReason || 'Draft created',
    creationDate: now
  });

  return {
    success: true,
    statusCode: 201,
    data: draftLead
  };
};

module.exports = { saveDraftData };
