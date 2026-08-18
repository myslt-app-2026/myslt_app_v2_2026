const { v4: uuidv4 } = require("uuid");
const DataGiftPrepaidOrder = require("../../../models/TMF622_ProductOrder");

/**
 * POST /BBVAS/PurchaseAdvancedReportsPrepaidInit
 * Original params: subscriberID, reporterPackage, activatedBy
 * TMF reimplementation: params moved to request body
 */
exports.purchaseAdvancedReportsPrepaidInit = async (req, res) => {
  try {
    const { subscriberID, reporterPackage, activatedBy } = req.body;

    // Validate required fields
    if (!subscriberID || !reporterPackage || !activatedBy) {
      return res.status(400).json({
        error:
          "Missing required fields in request body: subscriberID, reporterPackage, activatedBy",
      });
    }

    const orderId = uuidv4();

    const newOrder = new DataGiftPrepaidOrder({
      id: orderId,
      href: `http://localhost:3000/tmf-api/usageManagement/v4/BBVAS/PurchaseAdvancedReportsPrepaidInit/${orderId}`,
      description: "Prepaid Advanced Report Purchase Init",
      category: "PurchaseAdvancedReportsPrepaid",
      state: "acknowledged",
      relatedParty: [
        {
          id: subscriberID,
          role: "Customer",
          name: activatedBy,
          "@referredType": "Customer",
        },
      ],
      productOrderItem: [
        {
          id: uuidv4(),
          action: "add",
          productOffering: {
            id: String(reporterPackage),
            name: `Advanced Report Package ${reporterPackage}`,
            "@referredType": "ProductOffering",
          },
          quantity: 1,
        },
      ],
      channel: [
        {
          name: "MySLT App",
          "@referredType": "Channel",
        },
      ],
      orderDate: new Date(),
    });

    await newOrder.save();

    return res.status(201).json({
      message: "Prepaid Advanced Report Init successful",
      data: newOrder,
    });
  } catch (error) {
    console.error("Error in PurchaseAdvancedReportsPrepaidInit:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};