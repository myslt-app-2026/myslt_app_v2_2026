const DigitalIdentity = require("../../../models/TMF720_DigitalIdentity");

const getProtectedResource = async (user) => {

  // save access log to TMF720
  const identity = await DigitalIdentity.create({
    status: "Active",
    party: [
      {
        id: user.id,
        name: user.username,
        href: `/tmf-api/partyManagement/v5/individual/${user.id}`
      }
    ],
    credential: [
      {
        token: "ACCESS_GRANTED",
        validFor: {
          startDateTime: new Date(),
          endDateTime: new Date(Date.now() + 15 * 60 * 1000)
        },
        status: "Active"
      }
    ]
  });

  return {
    success: true,
    statusCode: 200,
    message: "Access granted to protected resource",
    data: {
      id: identity.id,
      userId: user.id,
      username: user.username,
      resource: "ProtectedResource",
      accessedAt: new Date().toISOString(),
      credential: identity.credential,
      "@type": "DigitalIdentity"
    }
  };
};

module.exports = { getProtectedResource };