const mongoose = require("mongoose");
const dotenv = require("dotenv");
const connectDB = require('../../config/db'); // Adjust based on actual structure
const VASDataBundle = require('./models/addVASDataBundlePrepaidInit.model.js');

dotenv.config();
connectDB();

const seedData = async () => {
  try {
    await VASDataBundle.deleteMany();

    const bundles = [
      {
        id: "VAS1001",
        customerId: "CUST001",
        bundleName: "5GB Prepaid Data",
        dataVolume: "5GB",
        validity: "30 Days",
        price: 500,
      },
      {
        id: "VAS1002",
        customerId: "CUST002",
        bundleName: "10GB Prepaid Data",
        dataVolume: "10GB",
        validity: "45 Days",
        price: 900,
      },
    ];

    await VASDataBundle.insertMany(bundles);
    console.log("✅ VAS Data Bundles Seeded!");
    process.exit();
  } catch (error) {
    console.error("❌ Seed Error:", error.message);
    process.exit(1);
  }
};

seedData();