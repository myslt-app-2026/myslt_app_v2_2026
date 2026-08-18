const {
  getCallForwardingRequest,
} = require("../services/callForwardingRequestService");

const callForwardingRequest = async (req, res) => {
  try {
    const result = await getCallForwardingRequest(req.query);

    return res.status(result.statusCode).json(result);
  } catch (err) {
    console.error(err);

    return res.status(500).json({
      success: false,
      statusCode: 500,
      message: "Internal Server Error",
    });
  }
};

module.exports = {
  callForwardingRequest,
};