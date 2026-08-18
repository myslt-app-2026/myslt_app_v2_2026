/**
 * getDashboardVASBundlesService.js
 * ISP SOA Module — GET Dashboard VAS Bundles
 *
 * External ISP SOA endpoint:
 *   GET http://172.25.37.114:8085/dashboard/vas_data
 *
 * Forwards to ISP SOA server. Falls back to internal MongoDB on failure.
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

const getDashboardVASBundles = async (query = {}) => {
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
    const data = await fetchJson('/dashboard/vas_data', { subscriberID, billdate });

    return {
      success: true,
      statusCode: 200,
      source: 'ISP_SOA',
      data
    };

  } catch (externalError) {
    console.warn('[GETDashboardVASBundles] ISP SOA unreachable, falling back to internal DB:', externalError.message);

    // Fallback: query internal MongoDB
    const vasBundles = await TMF620ProductOffering.find({
      lifecycleStatus: { $regex: /^active$/i },
      $or: [
        { category:     { $regex: /vas/i } },
        { name:         { $regex: /vas/i } },
        { offeringType: { $regex: /vas/i } }
      ]
    }).lean();

    return {
      success: true,
      statusCode: 200,
      source: 'INTERNAL_DB_FALLBACK',
      subscriberID,
      count: vasBundles.length,
      data: vasBundles
    };
  }
};

module.exports = { getDashboardVASBundles };
