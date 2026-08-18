const initService = require("../services/exGBPurchasePrepaidInit.service");

// Required fields for ExGBPurchasePrepaidInit
const REQUIRED_FIELDS = ["subscriberId", "packageId"];

/**
 * POST /ExGBPurchasePrepaidInit
 * TMF622 – Creates a new ProductOrder (state: acknowledged)
 * for an Extra GB prepaid purchase initiation.
 */
exports.createExGBPrepaidInit = async (req, res) => {
  try {
    // ── 1. Validate required fields ──────────────────────────────────────────
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

    // ── 2. Create the order via service ──────────────────────────────────────
    const savedOrder = await initService.createExGBPrepaidInitOrder(req.body);

    // ── 3. Return TMF622-shaped response ─────────────────────────────────────
    return res.status(201).json({
      id:                      savedOrder.id,
      href:                    savedOrder.href,
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
    console.error("[ExGBPurchasePrepaidInit] Error:", error);

    // Duplicate order
    if (error.code === 11000) {
      return res.status(409).json({
        code:    "409",
        reason:  "Conflict",
        message: "A ProductOrder with this ID already exists.",
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