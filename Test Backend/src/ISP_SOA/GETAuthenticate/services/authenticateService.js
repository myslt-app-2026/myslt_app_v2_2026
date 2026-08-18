const bcrypt = require("bcryptjs");
const User = require("../../../Account/RegisterV2/models/user");
const DigitalIdentity = require("../../../models/TMF720_DigitalIdentity");
const {
  generateAccessToken,
  generateRefreshToken
} = require("../../../utilities/jwt");

const authenticate = async (query) => {

  const { username, password } = query;

  if (!username || !password) {
    return {
      success: false,
      statusCode: 400,
      message: "username and password are required"
    };
  }

  // find user
  const user = await User.findOne({ username });

  if (!user) {
    return {
      success: false,
      statusCode: 401,
      message: "Invalid username or password"
    };
  }

  if (user.status !== "ACTIVE") {
    return {
      success: false,
      statusCode: 401,
      message: "User is not activated"
    };
  }

  // validate password
  const isValid = await bcrypt.compare(password, user.passwordHash);

  if (!isValid) {
    return {
      success: false,
      statusCode: 401,
      message: "Invalid username or password"
    };
  }

  // generate tokens
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  // save refresh token
  user.refreshToken = refreshToken;
  await user.save();

  // save to TMF720 DigitalIdentity
  await DigitalIdentity.create({
    status: "Active",
    party: [{
      id: user._id.toString(),
      name: `${user.individual?.firstName || ""} ${user.individual?.lastName || ""}`.trim(),
      href: `/tmf-api/partyManagement/v5/individual/${user._id}`
    }],
    credential: [{
      token: accessToken,
      validFor: {
        startDateTime: new Date(),
        endDateTime: new Date(Date.now() + 15 * 60 * 1000) // 15 mins
      },
      status: "Active"
    }]
  });

  return {
    success: true,
    statusCode: 200,
    accessToken,
    refreshToken,
    user_id: user._id,
    name: `${user.individual?.firstName || ""} ${user.individual?.lastName || ""}`.trim()
  };
};

module.exports = { authenticate };