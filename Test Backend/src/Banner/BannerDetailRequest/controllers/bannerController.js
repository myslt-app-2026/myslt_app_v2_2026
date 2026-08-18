// TMF681 - Communication Management v4 - BannerDetailRequest
const bannerService = require('../services/bannerService');

exports.getBannerDetails = async (req, res) => {
  try {
    const { username } = req.query;
    
    const filters = {};
    
    // Filter by receiver username if provided
    if (username) {
      filters['receiver.party.partyOrPartyRole.id'] = username;
    }
    
    // Return all fields for TMF 681 compliance
    const communications = await bannerService.getBannerDetails(filters, null);

    res.status(200).json({
      "@type": "CommunicationMessage",
      "@schemaLocation": "/tmf-api/communicationManagement/v4/schema/communicationMessage",
      communications
    });
    
  } catch (error) {
    console.error('Error fetching communication messages:', error);
    res.status(500).json({ 
      status: 500, 
      message: error.message 
    });
  }
};
