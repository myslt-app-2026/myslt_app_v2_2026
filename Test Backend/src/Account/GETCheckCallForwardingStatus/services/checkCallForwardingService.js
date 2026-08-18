const https = require('https');

const checkCallForwardingStatus = (query = {}, authHeader) => {
  return new Promise((resolve, reject) => {
    // Build query string from whatever params are passed
    const params = new URLSearchParams(query).toString();
    const path = `/api/Account/GETCheckCallForwardingStatus${params ? '?' + params : ''}`;

    const req = https.request(
      {
        hostname: 'omni.slt.com.lk',
        path,
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          ...(authHeader && { Authorization: authHeader })
        }
      },
      (res) => {
        let raw = '';
        res.on('data', (chunk) => { raw += chunk; });
        res.on('end', () => {
          try { resolve({ success: true, statusCode: res.statusCode, data: JSON.parse(raw) }); }
          catch { resolve({ success: true, statusCode: res.statusCode, data: raw }); }
        });
      }
    );
    req.setTimeout(10000, () => { req.destroy(new Error('Request timed out')); });
    req.on('error', reject);
    req.end();
  });
};

module.exports = { checkCallForwardingStatus };