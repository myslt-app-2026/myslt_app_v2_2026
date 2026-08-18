/**
 * TMF679 Product Offering Qualification Service
 * Handles multiple product offerings and routes to correct SLT mock API
 */

// Mock SLT API for Bonus Data
const checkBonusData = (subscriberID, productName) => {
  // Example logic
  const eligiblePackages = ["BonusData_10GB", "BonusData_5GB"];
  return {
    qualified: eligiblePackages.includes(productName),
    reason: eligiblePackages.includes(productName)
      ? "Eligible subscriber"
      : "Not eligible for bonus data"
  };
};

// Mock SLT API for VAS Data Bundle
const checkVASBundle = (subscriberID, productName) => {
  const availableVAS = ["FTTH_ANYTIME 75GB", "FTTH_ANYTIME 150GB"];
  return {
    qualified: availableVAS.includes(productName),
    reason: availableVAS.includes(productName)
      ? "Eligible subscriber"
      : "Not eligible for this VAS bundle"
  };
};

// Service function to create a ProductOfferingQualification and save to MongoDB
const createProductOfferingQualification = async (body) => {
  const items = body.productOfferingQualificationItem || [];

  if (items.length === 0) {
    throw new Error("At least one productOfferingQualificationItem is required");
  }

  const results = items.map((item) => {
    const subscriber = item?.relatedParty?.find((p) => p.role === "subscriber");
    const productName = item.productOffering?.name || "";

    if (!subscriber?.id || !productName) {
      return {
        ...item,
        qualificationResult: "unqualified",
        qualificationReason: "Missing subscriber ID or productOffering name",
      };
    }

    // Determine qualification
    let qualification;
    if (productName.toLowerCase().includes("bonus")) {
      qualification = checkBonusData(subscriber.id, productName);
    } else {
      qualification = checkVASBundle(subscriber.id, productName);
    }

    return {
      id: item.id || String(Date.now()),
      productOffering: item.productOffering,
      relatedParty: item.relatedParty,
      qualificationResult: qualification.qualified ? "qualified" : "unqualified",
      qualificationReason: qualification.reason,
    };
  });

  // Create MongoDB document
  const ProductOfferingQualification = require('../models/ProductOfferingQualification'); // CJS import
  const doc = new ProductOfferingQualification({
    id: `POQ-${Date.now()}`,
    state: "completed",
    productOfferingQualificationItem: results,
  });

  await doc.save(); // Persist to MongoDB

  return {
    success: true,
    status: 201,
    data: doc,
  };
};

// CJS export
module.exports = {
  createProductOfferingQualification,
};
