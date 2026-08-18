const CommunicationMessage = require('../../../../src/models/TMF681_CommunicationMessage.js');

async function getBannerDetails(filters, selectedFields) {
  try {
    const query = CommunicationMessage.find(filters);
    
    // Apply field selection if specified
    if (selectedFields) {
      query.select(selectedFields);
    }
    
    return await query.lean();
  } catch (error) {
    throw error;
  }
}

module.exports = { 
  getBannerDetails 
};
