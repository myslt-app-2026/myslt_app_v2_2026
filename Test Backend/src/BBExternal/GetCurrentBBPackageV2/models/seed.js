// seedBBProducts.js
const mongoose = require("mongoose");
const BBProduct = require("./product.model"); // adjust path if needed
const ProductOffering = require("../../GetBBPackagesV2/models/productOffering.model"); // for reference

// Replace with your MongoDB connection string
const MONGO_URI = "mongodb+srv://omnichannelservicehub_db_user:OmniChannel@cluster0.jgutgzr.mongodb.net/OmniChannel?retryWrites=true&w=majority";

// Example products referencing ProductOfferings
const seedData = [
  {
    _id: "PROD_BB_001",
    customerId: "CUST_001",
    status: "Active",
    category: "broadband",
    productOfferingId: "BB_SLT_4G_ANYTIDE",
    startDate: new Date("2026-01-01")
  },
  {
    _id: "PROD_BB_002",
    customerId: "CUST_002",
    status: "Active",
    category: "broadband",
    productOfferingId: "BB_FIBER_1TB",
    startDate: new Date("2026-01-05")
  },
  {
    _id: "PROD_BB_003",
    customerId: "CUST_003",
    status: "Suspended",
    category: "broadband",
    productOfferingId: "BB_FIBER_UNLIMITED",
    startDate: new Date("2025-12-15")
  },
  {
    _id: "PROD_BB_004",
    customerId: "CUST_004",
    status: "Active",
    category: "broadband",
    productOfferingId: "BB_SLT_4G_ANYTIDE",
    startDate: new Date("2026-01-10")
  }
];

async function seedDB() {
  try {
    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });

    console.log("MongoDB connected.");

    // Optional: check if ProductOfferings exist
    const offerings = await ProductOffering.find({});
    if (offerings.length === 0) {
      console.log("No ProductOfferings found. Seed them first.");
      process.exit(1);
    }

    // Clear existing BBProducts
    await BBProduct.deleteMany({});
    console.log("Existing BBProducts removed.");

    // Insert seed data
    await BBProduct.insertMany(seedData);
    console.log("BBProducts seed data inserted successfully.");

    process.exit(0);
  } catch (err) {
    console.error("Error seeding BBProducts:", err);
    process.exit(1);
  }
}

seedDB();
