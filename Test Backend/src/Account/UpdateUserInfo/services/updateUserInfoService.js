const https = require('https');

const updateUserInfo = (body = {}, authHeader) => {
  const { userName, altrContact, name } = body;

  if (!userName) {
    return Promise.resolve({
      success: false,
      statusCode: 400,
      message: 'userName is required'
    });
  }

  return new Promise((resolve, reject) => {
    const postData = JSON.stringify({ userName, altrContact, name });

    const req = https.request(
      {
        hostname: 'omni.slt.com.lk',
        path: '/api/Account/UpdateUserInfo',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData),
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
    req.write(postData);
    req.end();
  });
};

module.exports = { updateUserInfo };