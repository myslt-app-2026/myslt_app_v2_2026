const crypto = require("crypto");

const getPeoTVGOAccessToken = async ({ subscriberId, channel = "WEB" }) => {
  const issuedAt = new Date();
  const expiresIn = 3600;

  return {
    accessToken: `PEOTVGO-${crypto.randomUUID()}`,
    tokenType: "Bearer",
    expiresIn,
    issuedAt: issuedAt.toISOString(),
    expiresAt: new Date(
      issuedAt.getTime() + expiresIn * 1000
    ).toISOString(),
    subscriberId,
    channel,
    status: "SUCCESS",
  };
};

module.exports = {
  getPeoTVGOAccessToken,
};