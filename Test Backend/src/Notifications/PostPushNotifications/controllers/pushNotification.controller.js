const pushService = require('../services/pushNotification.service');

exports.sendPushNotification = async (req, res) => {
  try {
    const {
      accountNo,
      NotType,
      email,
      mobile
    } = req.body;

    // Basic validation
    if (!accountNo || !NotType || (!email && !mobile)) {
      return res.status(400).json(
        buildErrorResponse(
          'Invalid request payload',
          'accountNo, NotType and at least one contact (email or mobile) are mandatory'
        )
      );
    }

    // Delegate to service (TMF-681 resource creation)
    const message = await pushService.processPushNotification(req.body);

    return res.status(200).json({
      isSuccess: true,
      errorMessege: null,
      exceptionDetail: null,
      dataBundle: {
        messageId: message.id || message._id, // Prefer TMF id
        state: message.state,                 // TMF-compliant
        messageType: message.messageType
      },
      errorShow: null,
      errorCode: null
    });

  } catch (err) {
    return res.status(500).json(buildExceptionResponse(err));
  }
};

/**
 * ===== Error Builders =====
 */

function buildExceptionResponse(err) {
  return {
    isSuccess: false,
    errorMessege: 'Exception occurred while sending push notification for user',
    exceptionDetail: err.stack,
    dataBundle: null,
    errorShow:
      'Sorry, the service is temporarily unavailable. Please try again later.',
    errorCode: null
  };
}

function buildErrorResponse(message, detail) {
  return {
    isSuccess: false,
    errorMessege: message,
    exceptionDetail: detail,
    dataBundle: null,
    errorShow: message,
    errorCode: null
  };
}
