/**
 * getFreeDataService.js
 * ISP SOA Module — GET FreeData
 *
 * External ISP SOA endpoint:
 *   GET http://172.25.37.114:8085/dashboard/free_data
 *
 * This service forwards the request to the ISP SOA server and returns
 * the response back to the client. If the external server is unreachable,
 * falls back to internal MongoDB (TMF620_ProductOffering) data.
 */

const axios = require('axios');
const TMF620ProductOffering = require('../../../models/TMF620_ProductOffering');

const ISP_SOA_BASE_URL = 'http://172.25.37.114:8085';

const getFreeData = async (query = {}) => {
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
    const response = await axios.get(`${ISP_SOA_BASE_URL}/dashboard/free_data`, {
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
    console.warn('[GETFreeData] ISP SOA unreachable, falling back to internal DB:', externalError.message);

    // Fallback: query internal MongoDB
    const freePackages = await TMF620ProductOffering.find({
      lifecycleStatus: { $regex: /^active$/i },
      $or: [
        { category:     { $regex: /free/i } },
        { name:         { $regex: /free/i } },
        { offeringType: { $regex: /free/i } }
      ]
    }).lean();

    return {
      success: true,
      statusCode: 200,
      source: 'INTERNAL_DB_FALLBACK',
      subscriberID,
      count: freePackages.length,
      data: freePackages
    };
  }
};

module.exports = { getFreeData };
