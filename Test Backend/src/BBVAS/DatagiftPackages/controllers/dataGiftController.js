const DataGiftPackage = require("../../../models/TMF620_ProductOffering");

// Add new data gift package
exports.addDataGiftPackage = async (req, res) => {
  try {
    const { packageName, dataAmount, unit, price, status } = req.body;
    const subscriberID = "94112647459";

    if (!packageName || !dataAmount) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "packageName and dataAmount are required",
        status:  "400",
        "@type": "Error",
      });
    }

    const newPackage = new DataGiftPackage({
      name:        packageName,
      description: `${dataAmount} ${unit || "MB"} Data Gift Package`,
      lifecycleStatus: status || "Active",
      offeringType: "DataGift",
      category:    "DataGift",
    });

    const savedPackage = await newPackage.save();
    res.status(201).json(savedPackage);

  } catch (error) {
    console.error("Error adding Data Gift Package:", error);
    res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};

exports.listDataGiftPackages = async (req, res) => {
  try {
    const { subscriberID } = req.params;

    if (!subscriberID) {
      return res.status(400).json({
        code:    "400",
        reason:  "Validation Error",
        message: "subscriberID is required",
        status:  "400",
        "@type": "Error",
      });
    }

    const packages = await DataGiftPackage.find({
      category: { $regex: /DataGift/i },
      lifecycleStatus: "Active"
    });

    res.status(200).json({
      subscriberID,
      packages: packages,
    });

  } catch (error) {
    console.error("Error fetching Data Gift Packages:", error);
    res.status(500).json({
      code:    "500",
      reason:  "Internal Server Error",
      message: error.message,
      status:  "500",
      "@type": "Error",
    });
  }
};