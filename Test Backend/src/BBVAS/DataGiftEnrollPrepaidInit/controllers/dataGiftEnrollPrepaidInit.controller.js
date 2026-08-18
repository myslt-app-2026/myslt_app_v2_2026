const dataGiftInitService = require("../services/dataGiftEnrollPrepaidInit.service");

const REQUIRED_FIELDS = [
  "senderId",
  "receiverId",
  "bundleName",
  "dataVolume",
  "validity",
];

exports.createDataGiftEnrollPrepaidInit = async (req, res) => {
  try {
    const missing = REQUIRED_FIELDS.filter((field) => !req.body[field]);
    if (missing.length > 0) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: `Missing required field(s): ${missing.join(", ")}`,
        status:  "400",
        "@type": "Error",
      });
    }

    const savedOrder = await dataGiftInitService.createPrepaidInitOrder(req.body);

    return res.status(201).json({
      id:                      savedOrder.id,
      href:                    savedOrder.href,
      externalId:              savedOrder.externalId,
      description:             savedOrder.description,
      category:                savedOrder.category,
      priority:                savedOrder.priority,
      state:                   savedOrder.state,
      orderDate:               savedOrder.orderDate,
      requestedStartDate:      savedOrder.requestedStartDate,
      requestedCompletionDate: savedOrder.requestedCompletionDate,
      channel:                 savedOrder.channel,
      relatedParty:            savedOrder.relatedParty,
      productOrderItem:        savedOrder.productOrderItem,
      note:                    savedOrder.note,
      "@type":                 savedOrder["@type"],
    });

  } catch (error) {
    console.error("[DataGiftEnrollPrepaidInit] Error:", error);
    if (error.code === 11000) {
      return res.status(409).json({
        code:    "409",
        reason:  "Conflict",
        message: "A DataGift order with this ID already exists.",
        status:  "409",
        "@type": "Error",
      });
    }
    return res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};
