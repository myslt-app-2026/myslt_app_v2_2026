const { v4: uuidv4 } = require("uuid");
const TMF679 = require("../../../models/TMF679_ProductOffering");

async function validateBBPurchase(subscriberId, packageId, channel) {
  const qualificationId = uuidv4();
  const isQualified = true;

  const qualificationDoc = {
    id:                  qualificationId,
    subscriberId:        subscriberId,
    packageId:           packageId,
    channel:             channel || "MySLT",
    state:               isQualified ? "qualified" : "unqualified",
    qualificationResult: isQualified
      ? "Subscriber is eligible for BB purchase"
      : "Subscriber is not eligible for BB purchase",
    validationDate:      new Date(),
    "@type":             "ProductOfferingQualification",
  };

  const qualification = new TMF679(qualificationDoc);
  const saved = await qualification.save();
  return saved;
}

module.exports = { validateBBPurchase };