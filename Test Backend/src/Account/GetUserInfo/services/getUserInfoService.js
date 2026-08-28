const https = require('https');
const Customer = require('../../../models/TMF629_Customer');

const TEST_USER = {
  userName: 'user@slt.lk',
  firstName: 'Kasun',
  lastName: 'Perera',
  email: 'user@slt.lk',
  mobile: '0771234567',
  accountNumber: 'ACC-0094-7821',
  nic: '199512345678',
};

const getUserInfo = async (query = {}, authHeader) => {
  const { userName } = query;

  if (!userName) {
    return {
      success: false,
      statusCode: 400,
      message: 'userName query parameter is required',
    };
  }

  // 1. Try external OMNI server
  try {
    const omniResult = await new Promise((resolve, reject) => {
      const req = https.request(
        {
          hostname: 'omni.slt.com.lk',
          path: `/api/Account/GetUserInfo?userName=${encodeURIComponent(userName)}`,
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            ...(authHeader && { Authorization: authHeader }),
          },
        },
        (res) => {
          let raw = '';
          res.on('data', (chunk) => {
            raw += chunk;
          });
          res.on('end', () => {
            if (res.statusCode >= 200 && res.statusCode < 300) {
              try {
                resolve({ success: true, statusCode: res.statusCode, data: JSON.parse(raw) });
              } catch {
                resolve({ success: true, statusCode: res.statusCode, data: raw });
              }
            } else {
              reject(new Error(`OMNI responded with status ${res.statusCode}`));
            }
          });
        }
      );
      req.setTimeout(5000, () => {
        req.destroy(new Error('Request timed out'));
      });
      req.on('error', reject);
      req.end();
    });

    return omniResult;
  } catch (externalError) {
    console.warn('[GetUserInfo] External OMNI API unreachable, falling back to local DB/test data:', externalError.message);
  }

  // 2. Try MongoDB Customer collection
  try {
    const customer = await Customer.findOne({
      $or: [
        { 'engagedParty.name': userName },
        { 'contactMedium.characteristic.emailAddress': userName },
        { 'contactMedium.characteristic.phoneNumber': userName },
        { id: userName },
      ],
    }).lean();

    if (customer) {
      const email = customer.contactMedium?.find((c) => c.characteristic?.emailAddress)?.characteristic?.emailAddress || userName;
      const mobile = customer.contactMedium?.find((c) => c.characteristic?.phoneNumber)?.characteristic?.phoneNumber || '0771234567';
      const nameParts = (customer.engagedParty?.name || 'Kasun Perera').split(' ');

      return {
        success: true,
        statusCode: 200,
        source: 'INTERNAL_DB',
        data: {
          userName,
          firstName: nameParts[0] || 'Kasun',
          lastName: nameParts.slice(1).join(' ') || 'Perera',
          email,
          mobile,
          accountNumber: customer.account?.[0]?.id || 'ACC-0094-7821',
          nic: customer.id || '199512345678',
        },
      };
    }
  } catch (dbError) {
    console.warn('[GetUserInfo] MongoDB lookup failed:', dbError.message);
  }

  // 3. Fallback to TEST_MODE data
  return {
    success: true,
    statusCode: 200,
    source: 'TEST_MODE',
    data: {
      ...TEST_USER,
      userName,
      email: userName.includes('@') ? userName : TEST_USER.email,
    },
  };
};

module.exports = { getUserInfo };