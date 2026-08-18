const getCallForwardingRequest = async (query = {}) => {
  const { telephoneNo, mobileNo, requestType } = query;

  if (!telephoneNo || !mobileNo || !requestType) {
    return {
      success: false,
      statusCode: 400,
      message:
        "telephoneNo, mobileNo and requestType are required",
    };
  }

  return {
    success: true,
    statusCode: 200,
    message: "Call Forwarding Request Retrieved Successfully",
    data: {
      telephoneNo,
      mobileNo,
      requestType,
      forwardingStatus: "ACTIVE",
      forwardingNumber: mobileNo,
    },
  };
};

module.exports = {
  getCallForwardingRequest,
};