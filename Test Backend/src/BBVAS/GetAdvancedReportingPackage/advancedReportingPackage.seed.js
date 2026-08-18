require('dotenv').config();
const mongoose = require('mongoose');
const connectDB = require('../../config/db.js');
const AdvancedReportingPackage = require('./models/advancedReportingPackage.model.js');

const seedData = [
  {
    id: "arp-001",
    name: "Q1 2025 Financial Report",
    description: "Advanced reporting package for Q1 2025 financials",
    reportType: "financial",
    status: "available",
    downloadLink: "/downloads/reports/arp-001.pdf"
  },
  {
    id: "arp-002",
    name: "Customer Satisfaction Insights",
    description: "Customer experience report package for 2025",
    reportType: "customer",
    status: "available",
    downloadLink: "/downloads/reports/arp-002.pdf"
  }
];

async function seedAdvancedReportingPackages() {
  try {
    await connectDB();

    await AdvancedReportingPackage.deleteMany({});
    console.log("🗑️ Cleared old AdvancedReportingPackages");

    await AdvancedReportingPackage.insertMany(seedData);
    console.log("🌱 AdvancedReportingPackages seeded successfully");

    mongoose.connection.close();
  } catch (err) {
    console.error("❌ Error seeding AdvancedReportingPackages:", err);
    mongoose.connection.close();
  }
}

seedAdvancedReportingPackages();
