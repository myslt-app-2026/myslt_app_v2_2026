const pushService = require("../services/pushNotificationService");

exports.sendPushNotification = async (req, res) => {
  try {
    const {
      accountNo,
      NotType,
      email,
      mobile,
      billMonth,
      BillCode,
      BillMode
    } = req.body;

    if (!accountNo || !NotType || (!email && !mobile)) {
      return res.status(400).json({
        isSuccess:       false,
        errorMessege:    "Invalid request payload",
        exceptionDetail: "accountNo, NotType and at least one contact (email or mobile) are mandatory",
        dataBundle:      null,
        errorShow:       "Invalid request payload",
        errorCode:       null
      });
    }

    const message = await pushService.processPushNotification(req.body);

    return res.status(200).json({
      isSuccess:       true,
      errorMessege:    null,
      exceptionDetail: null,
      dataBundle: {
        messageId:   message.id || message._id,
        state:       message.state,
        messageType: message.messageType
      },
      errorShow: null,
      errorCode: null
    });

  } catch (err) {
    return res.status(500).json({
      isSuccess:       false,
      errorMessege:    "Exception occurred while sending push notification",
      exceptionDetail: err.stack,
      dataBundle:      null,
      errorShow:       "Sorry, the service is temporarily unavailable. Please try again later.",
      errorCode:       null
    });
  }
};