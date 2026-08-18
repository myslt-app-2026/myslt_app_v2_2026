const SalesLead = require('../../../models/TMF699_SalesLead');

const updateDraftDataV2 = async (body = {}) => {
  const { id, ...updateFields } = body;

  if (!id) {
    return {
      success: false,
      statusCode: 400,
      message: 'Missing mandatory attribute: id'
    };
  }

  const existingLead = await SalesLead.findOne({ id });

  if (!existingLead) {
    return {
      success: false,
      statusCode: 404,
      message: `Draft record not found for id: ${id}`
    };
  }

  const allowedUpdates = [
    'name', 'description', 'type', 'rating', 'priority',
    'estimatedRevenue', 'validFor', 'marketSegment', 'marketingCampaign',
    'channel', 'productOffering', 'product', 'category',
    'salesOpportunity', 'note', 'relatedParty', 'prospectContact',
    'status', 'statusChangeReason'
  ];

  allowedUpdates.forEach((field) => {
    if (updateFields[field] !== undefined) {
      existingLead[field] = updateFields[field];
    }
  });

  existingLead.statusChangeDate = new Date();
  existingLead.statusChangeReason = updateFields.statusChangeReason || 'Draft updated';

  const updated = await existingLead.save();

  return {
    success: true,
    statusCode: 200,
    data: updated
  };
};

module.exports = { updateDraftDataV2 };
