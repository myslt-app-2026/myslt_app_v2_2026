require("dotenv").config();
const mongoose = require("mongoose");
const connectDB = require("../../config/db");
const Usage = require("../../models/TMF635_UsageManagement");

async function seed() {
  try {
    await connectDB();

    await Usage.deleteMany({ category: "DailyDataUsage" });

    await Usage.create([
      {
        subscriberID: "0771234567",
        category:     "DailyDataUsage",
        volume:       1.5,
        unit:         "GB",
        status:       "active",
        channel:      "MySLT",
      },
      {
        subscriberID: "0771234567",
        category:     "DailyDataUsage",
        volume:       2.3,
        unit:         "GB",
        status:       "active",
        channel:      "MySLT",
      },
      {
        subscriberID: "0771234567",
        category:     "DailyDataUsage",
        volume:       0.8,
        unit:         "GB",
        status:       "active",
        channel:      "MySLT",
      }
    ]);

    console.log("✅ Weekly usage seed data added!");
    mongoose.connection.close();

  } catch (err) {
    console.error("❌ Seeding error:", err.message);
    mongoose.connection.close();
  }
}

seed();