require('dotenv').config();
const mongoose = require('mongoose');
const connectDB = require('../../config/db.js');
const ReportTimePeriod = require('./models/reportTimePeriod.model.js');

const seedData = [
  {
    id: "rtp-001",
    name: "Q1 2025",
    description: "Reporting period for first quarter of 2025",
    startDateTime: new Date("2025-01-01T00:00:00Z"),
    endDateTime: new Date("2025-03-31T23:59:59Z"),
    status: "completed",
    href: "/tmf-api/reportManagement/v5/reportTimePeriod/rtp-001"
  },
  {
    id: "rtp-002",
    name: "Q2 2025",
    description: "Reporting period for second quarter of 2025",
    startDateTime: new Date("2025-04-01T00:00:00Z"),
    endDateTime: new Date("2025-06-30T23:59:59Z"),
    status: "completed",
    href: "/tmf-api/reportManagement/v5/reportTimePeriod/rtp-002"
  },
  {
    id: "rtp-003",
    name: "Q3 2025",
    description: "Reporting period for third quarter of 2025",
    startDateTime: new Date("2025-07-01T00:00:00Z"),
    endDateTime: new Date("2025-09-30T23:59:59Z"),
    status: "active",
    href: "/tmf-api/reportManagement/v5/reportTimePeriod/rtp-003"
  }
];

async function seedReportTimePeriods() {
  try {
    await connectDB();

    await ReportTimePeriod.deleteMany({});
    console.log("🗑️ Cleared old ReportTimePeriods");

    await ReportTimePeriod.insertMany(seedData);
    console.log("🌱 ReportTimePeriods seeded successfully");

    mongoose.connection.close();
  } catch (err) {
    console.error("❌ Error seeding ReportTimePeriods:", err);
    mongoose.connection.close();
  }
}

seedReportTimePeriods();
