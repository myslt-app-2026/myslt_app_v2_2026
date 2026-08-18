const packageActivationSOA = async (body = {}) => {
  const { subscriberId, packageId } = body;

  if (!subscriberId || !packageId) {
    return {
      success: false,
      statusCode: 400,
      message: "subscriberId and packageId are required",
    };
  }

  return {
    success: true,
    statusCode: 200,
    message: "Package activated successfully",
    data: {
      subscriberId,
      packageId,
      activationStatus: "ACTIVE",
    },
  };
};

module.exports = {
  packageActivationSOA,
};