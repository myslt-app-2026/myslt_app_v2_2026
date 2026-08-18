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

const TMF620ProductOffering = require('../../../models/TMF620_ProductOffering');

const ISP_SOA_BASE_URL = 'http://172.25.37.114:8085';

const fetchJson = async (path, params, timeoutMs = 10000) => {
  const url = new URL(path, ISP_SOA_BASE_URL);

  Object.entries(params).forEach(([key, value]) => {
    if (value !== undefined && value !== null && value !== '') {
      url.searchParams.set(key, value);
    }
  });

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, { signal: controller.signal });

    if (!response.ok) {
      throw new Error(`ISP SOA request failed with status ${response.status}`);
    }

    return await response.json();
  } finally {
    clearTimeout(timeoutId);
  }
};

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
    const data = await fetchJson('/dashboard/free_data', { subscriberID, billdate });

    return {
      success: true,
      statusCode: 200,
      source: 'ISP_SOA',
      data
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
