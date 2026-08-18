const SalesLead = require('../../../models/TMF699_SalesLead');
const { v4: uuidv4 } = require('uuid');

const saveDraftDataLTE = async (body = {}) => {
  const {
    name,
    description,
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
    href: `http://127.0.0.1:3000/tmf-api/sales/v4/draftDataLTE/${newId}`,
    '@type': 'SalesLead',
    name,
    description,
    type: 'LTE Lead',
    rating,
    priority,
    estimatedRevenue,
    validFor,
    marketSegment,
    marketingCampaign,
    channel,
    productOffering: productOffering || {
      id: 'LTE001',
      href: 'http://127.0.0.1:3000/tmf-api/productCatalogManagement/v4/productOffering/LTE001',
      name: 'SLT 4G/LTE Broadband'
    },
    product,
    category: category || {
      id: 'CATLTE',
      href: 'http://127.0.0.1:3000/tmf-api/productCatalogManagement/v4/category/CATLTE',
      name: 'LTE Category'
    },
    salesOpportunity,
    note,
    relatedParty,
    prospectContact,
    status: 'draft',
    statusChangeDate: now,
    statusChangeReason: statusChangeReason || 'LTE Draft created',
    creationDate: now
  });

  return {
    success: true,
    statusCode: 201,
    data: draftLead
  };
};

module.exports = { saveDraftDataLTE };
