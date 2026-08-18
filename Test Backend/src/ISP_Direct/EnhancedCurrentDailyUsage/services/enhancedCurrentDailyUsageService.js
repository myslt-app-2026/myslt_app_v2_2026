const http = require('http');
const UsageManagement = require('../../../models/TMF635_UsageManagement');

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

const getEnhancedCurrentDailyUsage = async (subscriberid, billdate = '10') => {
  if (!subscriberid) {
    return { success: false, statusCode: 400, message: "'subscriberid' header is required" };
  }

  try {
    const { statusCode, data } = await fetchFromISPDirect(
      `/enahanceddailyusage/current?billdate=${billdate}`,
      subscriberid
    );
    return { success: true, statusCode, source: 'ISP_DIRECT', data };
  } catch (err) {
    console.warn('[EnhancedCurrentDailyUsage] ISP Direct unreachable, falling back to MongoDB:', err.message);

    const usageData = await UsageManagement.find({ subscriberID: subscriberid }).lean();

    return {
      success: true,
      statusCode: 200,
      source: 'INTERNAL_DB_FALLBACK',
      subscriberid,
      billdate,
      count: usageData.length,
      data: usageData
    };
  }
};

module.exports = { getEnhancedCurrentDailyUsage };