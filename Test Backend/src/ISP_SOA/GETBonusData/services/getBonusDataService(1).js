/**
 * getBonusDataService.js
 * ISP SOA Module — GET BonusData
 *
 * External ISP SOA endpoint:
 *   GET http://172.25.37.114:8085/dashboard/bonus_data
 *
 * Forwards to ISP SOA server. Falls back to internal MongoDB on failure.
 */

const axios = require('axios');
const TMF620ProductOffering = require('../../../models/TMF620_ProductOffering');

const ISP_SOA_BASE_URL = 'http://172.25.37.114:8085';

const getBonusData = async (query = {}) => {
  const { subscriberID, billdate } = query;

  if (!subscriberID) {
    return {
      success: false,
      statusCode: 400,
      message: 'subscriberID is required'
    };
  }

  try {
    // Forward to ISP SOA external server
    const response = await axios.get(`${ISP_SOA_BASE_URL}/dashboard/bonus_data`, {
      params: { subscriberID, billdate },
      timeout: 10000
    });

    return {
      success: true,
      statusCode: 200,
      source: 'ISP_SOA',
      data: response.data
    };

  } catch (externalError) {
    console.warn('[GETBonusData] ISP SOA unreachable, falling back to internal DB:', externalError.message);

    // Fallback: query internal MongoDB
    const bonusPackages = await TMF620ProductOffering.find({
      lifecycleStatus: { $regex: /^active$/i },
      $or: [
        { category:     { $regex: /bonus/i } },
        { name:         { $regex: /bonus/i } },
        { offeringType: { $regex: /bonus/i } }
      ]
    }).lean();

    return {
      success: true,
      statusCode: 200,
      source: 'INTERNAL_DB_FALLBACK',
      subscriberID,
      count: bonusPackages.length,
      data: bonusPackages
    };
  }
};

module.exports = { getBonusData };
