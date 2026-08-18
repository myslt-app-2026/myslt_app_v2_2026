const https = require('https');

const getUserInfo = (query = {}, authHeader) => {
  const { userName } = query;

  if (!userName) {
    return Promise.resolve({
      success: false,
      statusCode: 400,
      message: 'userName query parameter is required'
    });
  }

  return new Promise((resolve, reject) => {
    const req = https.request(
      {
        hostname: 'omni.slt.com.lk',
        path: `/api/Account/GetUserInfo?userName=${encodeURIComponent(userName)}`,
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

module.exports = { getUserInfo };