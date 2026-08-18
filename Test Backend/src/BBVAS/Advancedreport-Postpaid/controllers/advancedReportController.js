const AdvancedReportPurchase = require("../models/advancedReportPurchase");

exports.purchaseAdvancedReportPostPaid = async (req, res) => {
  try {
    const { subscriberID, reporterPackage, activatedBy } = req.query;

    if (!subscriberID || !reporterPackage || !activatedBy) {
      return res.status(400).json({ error: "Missing required parameters" });
    }

    const purchase = new AdvancedReportPurchase({
      subscriberID,
      reporterPackage,
      activatedBy,
      status: "activated",
    });

    await purchase.save();

    res.status(201).json(purchase.toTMF());
  } catch (error) {
    console.error("Error purchasing advanced report:", error);
    res.status(500).json({ error: "Server error" });
  }
};
