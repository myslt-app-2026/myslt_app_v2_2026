const https = require('https');

const getAlexaAccessToken = (body = {}) => {
  const { grant_type, code, client_id } = body;

  if (!grant_type || !code || !client_id) {
    return Promise.resolve({
      success: false,
      statusCode: 400,
      message: 'grant_type, code, and client_id are required'
    });
  }

  return new Promise((resolve, reject) => {
    const postData = JSON.stringify({ grant_type, code, client_id });

    const req = https.request(
      {
        hostname: 'omni.slt.com.lk',
        path: '/api/Account/GetAlexaAccessToken/',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData)
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
    req.write(postData);
    req.end();
  });
};

module.exports = { getAlexaAccessToken };