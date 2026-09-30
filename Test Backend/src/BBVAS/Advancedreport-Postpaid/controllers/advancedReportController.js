const AdvancedReportPurchase = require("../models/advancedReportPurchase");

exports.purchaseAdvancedReportPostPaid = async (req, res) => {
  try {
    const subscriberID = req.query.subscriberID || req.body.subscriberID || req.body.accountNumber || "0312241780";
    const reporterPackage = req.query.reporterPackage || req.body.reporterPackage || req.body.packageId || "ADV_REPORT_01";
    const activatedBy = req.query.activatedBy || req.body.activatedBy || "MYSLT_APP";

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
