const http = require('http');
const TMF637Product = require('../../../models/TMF637_Product');

const ISP_DIRECT_BASE = { host: '10.68.74.136', port: 8081 };

const fetchFromISPDirect = (path, subscriberid) => {
  return new Promise((resolve, reject) => {
    const req = http.request(
      {
        hostname: ISP_DIRECT_BASE.host,
        port: ISP_DIRECT_BASE.port,
        path,
        method: 'GET',
        headers: { subscriberid, 'Content-Type': 'application/json' }
      },
      (res) => {
        let raw = '';
        res.on('data', (chunk) => { raw += chunk; });
        res.on('end', () => {
          try { resolve({ statusCode: res.statusCode, data: JSON.parse(raw) }); }
          catch { resolve({ statusCode: res.statusCode, data: raw }); }
        });
      }
    );
    req.setTimeout(8000, () => { req.destroy(new Error('ISP Direct request timed out')); });
    req.on('error', reject);
    req.end();
  });
};

const getMyPackage = async (subscriberid) => {
  if (!subscriberid) {
    return { success: false, statusCode: 400, message: "'subscriberid' header is required" };
  }

  try {
    const { statusCode, data } = await fetchFromISPDirect('/dashboard/mypackage', subscriberid);
    return { success: true, statusCode, source: 'ISP_DIRECT', data };
  } catch (err) {
    console.warn('[MyPackage] ISP Direct unreachable, falling back to MongoDB:', err.message);

    const products = await TMF637Product.find({
      status: { $in: ['active', 'Active'] },
      $or: [
        { 'relatedParty.id': subscriberid },
        { customerId: subscriberid },
        { publicIdentifier: subscriberid }
      ]
    }).lean();

    return {
      success: true,
      statusCode: 200,
      source: 'INTERNAL_DB_FALLBACK',
      subscriberid,
      count: products.length,
      data: products
    };
  }
};

module.exports = { getMyPackage };