const PopupMessage = require("../../../../src/models/Notifications_popupMessage.model");

const getPopupMessageBanner = async (req, res) => {
  try {
    const { subscriberID } = req.query;

    // ================= VALIDATION =================
    if (!subscriberID) {
      return res.status(400).json({
        isSuccess: false,
        errorMessage: "subscriberID is required",
        exceptionDetail: null,
        dataBundle: [],
        errorShow: true,
        errorCode: "ERR_MISSING_SUBSCRIBER_ID"
      });
    }

    // ================= QUERY =================
    const now = new Date();

    const records = await PopupMessage.find({
      lifecycleStatus: "ACTIVE",
      $and: [
        {
          $or: [
            { subscriber_id: subscriberID },
            { subscriber_id: { $exists: false } },
            { subscriber_id: null }
          ]
        },
        {
          $or: [
            { validFor: { $exists: false } },
            {
              "validFor.startDateTime": { $lte: now },
              "validFor.endDateTime": { $gte: now }
            }
          ]
        }
      ]
    }).lean();

    // ================= RESPONSE MAPPING =================
    const dataBundle = records.map(item => ({
      notid: item.id,
      title: item.title || "",
      message: item.message || "",
      popup_URL: item.popup_URL || "",
      action: item.action || "",
      popup_TYPE: item.popup_TYPE || "",
      button_TITLE: item.button_TITLE || "",
      noT_TYPE: item.noT_TYPE || "",
      noT_DATE: item.noT_DATE ? item.noT_DATE.toISOString() : "",
      status: item.status || "ACTIVE",
      button_NAME: item.button_NAME || "",
      created_USER: item.created_USER || "",
      created_DATE: item.created_DATE ? item.created_DATE.toISOString() : ""
    }));

    // ================= SUCCESS =================
    return res.status(200).json({
      isSuccess: true,
      errorMessage: null,
      exceptionDetail: null,
      dataBundle,
      errorShow: null,
      errorCode: null
    });

  } catch (err) {
    // ================= ERROR =================
    return res.status(500).json({
      isSuccess: false,
      errorMessage: "Unexpected error",
      exceptionDetail: err.message,
      dataBundle: [],
      errorShow: false,
      errorCode: "ERR_INTERNAL_SERVER"
    });
  }
};

module.exports = {
  getPopupMessageBanner
};
