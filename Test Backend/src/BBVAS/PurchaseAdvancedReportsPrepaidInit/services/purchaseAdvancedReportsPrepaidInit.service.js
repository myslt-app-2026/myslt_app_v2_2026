const { v4: uuidv4 } = require("uuid");
const PurchaseAdvancedReportsPrepaidInit = require("../models/purchaseAdvancedReportsPrepaidInit.model");

/**
 * Create a new Prepaid Advanced Report Init request
 */
async function createInitRequest(subscriberID, reportPackageID, requestedBy) {
  const transactionRef = uuidv4(); // unique reference for two-phase commit

  const initRecord = new PurchaseAdvancedReportsPrepaidInit({
    subscriberID,
    reportPackageID,
    requestedBy,
    status: "initiated",
    transactionRef,
  });

  await initRecord.save();
  return initRecord;
}

/**
 * Get all Init requests
 */
async function getAllInitRequests() {
  return await PurchaseAdvancedReportsPrepaidInit.find();
}

/**
 * Get Init request by transactionRef
 */
async function getInitByRef(transactionRef) {
  return await PurchaseAdvancedReportsPrepaidInit.findOne({ transactionRef });
}

module.exports = {
  createInitRequest,
  getAllInitRequests,
  getInitByRef,
};