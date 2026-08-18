const DataGiftPrepaidOrder = require("../../../models/TMF622_ProductOrder");

/**
 * POST /BBVAS/PurchaseAdvancedReportsPrepaidConfirm
 * Original params: subscriberID, paygatetransid, activatedBy, transID
 * TMF reimplementation: params moved to request body
 * transID = the order id returned from the Init step
 */
exports.purchaseAdvancedReportsPrepaidConfirm = async (req, res) => {
  try {
    const { subscriberID, paygatetransid, activatedBy, transID } = req.body;

    // Validate required fields
    if (!subscriberID || !paygatetransid || !activatedBy || !transID) {
      return res.status(400).json({
        error:
          "Missing required fields in request body: subscriberID, paygatetransid, activatedBy, transID",
      });
    }

    // Step 1 — Check if the order exists at all with this transID and subscriberID
    const existingRecord = await DataGiftPrepaidOrder.findOne({
      id: transID,
      "relatedParty.id": subscriberID,
    });

    if (!existingRecord) {
      return res.status(404).json({
        error: "No order found for the provided transID and subscriberID.",
      });
    }

    // Step 2 — Check if already confirmed
    if (existingRecord.state === "completed") {
      return res.status(409).json({
        error: "This order has already been confirmed and cannot be confirmed again.",
      });
    }

    // Step 3 — Check if cancelled or failed
    if (
      existingRecord.state === "cancelled" ||
      existingRecord.state === "failed"
    ) {
      return res.status(400).json({
        error: `This order is '${existingRecord.state}' and cannot be confirmed.`,
      });
    }

    // Step 4 — Check if state is acknowledged (valid to confirm)
    if (existingRecord.state !== "acknowledged") {
      return res.status(400).json({
        error: `This order is in '${existingRecord.state}' state and cannot be confirmed.`,
      });
    }

    // Step 5 — All checks passed, update the order
    existingRecord.state = "completed";
    existingRecord.completionDate = new Date();
    existingRecord.externalId.push({
      id: String(paygatetransid),
      owner: activatedBy,
      externalIdentifierType: "paygatetransid",
      "@type": "ExternalIdentifier",
    });
    await existingRecord.save();

    return res.status(200).json({
      message: "Prepaid Advanced Report Purchase Confirmed successfully",
      data: existingRecord,
    });
  } catch (error) {
    console.error("Error in PurchaseAdvancedReportsPrepaidConfirm:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};