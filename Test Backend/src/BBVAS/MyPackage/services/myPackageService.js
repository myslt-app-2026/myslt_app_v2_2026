const MyPackage = require("../models/myPackageModel");

const getMyPackageBySubscriber = async (subscriberID) => {
  const query = {
    status: { $in: ["active", "Active"] },
    $or: [
      { "relatedParty.id": subscriberID },
      { customerId: subscriberID },
      { publicIdentifier: subscriberID }
    ]
  };

  const myPackages = await MyPackage.find(query).lean();

  return {
    isSuccess: true,
    subscriberID,
    count: myPackages.length,
    data: myPackages,
  };
};

module.exports = { getMyPackageBySubscriber };
