const getTokenStatus = async (body = {}) => {

  const { token } = body;

  if (!token) {
    return {
      success: false,
      statusCode: 400,
      message: "token is required"
    };
  }

  return {
    success: true,
    statusCode: 200,
    message: "Token is valid",
    data: {
      token,
      status: "ACTIVE"
    }
  };
};

module.exports = { getTokenStatus };