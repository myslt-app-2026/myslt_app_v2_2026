const TMF637Product = require('../../../models/TMF637_Product');

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
    if (!response.ok) throw new Error(`ISP SOA responded with status ${response.status}`);
    return await response.json();
  } finally {
    clearTimeout(timeoutId);
  }
};

const getDashboardSummary = async (query = {}) => {
  const { subscriberID } = query;

  if (!subscriberID) {
    return { success: false, statusCode: 400, message: 'subscriberID is required' };
  }

  try {
    const data = await fetchJson('/dashboard/summary', { subscriberID });
    return { success: true, statusCode: 200, source: 'ISP_SOA', data };
  } catch (externalError) {
    console.warn('[GETDashboardSummary] ISP SOA unreachable, falling back to MongoDB:', externalError.message);

    const products = await TMF637Product.find({
      status: { $in: ['active', 'Active'] },
      $or: [
        { 'relatedParty.id': subscriberID },
        { customerId: subscriberID },
        { publicIdentifier: subscriberID }
      ]
    }).lean();

    return {
      success: true,
      statusCode: 200,
      source: 'INTERNAL_DB_FALLBACK',
      subscriberID,
      count: products.length,
      data: products
    };
  }
};

module.exports = { getDashboardSummary };