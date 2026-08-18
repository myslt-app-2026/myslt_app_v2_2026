const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
require("dotenv").config();

const DataGiftEnroll = require("./models/dataGiftEnroll.model.js");

// ✅ Connect DB
async function connectDB() {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("✅ MongoDB connected for seeding...");
  } catch (err) {
    console.error("❌ DB Connection Error:", err.message);
    process.exit(1);
  }
}

// ✅ Seed Data
async function seedData() {
  try {
    // Clear old records
    await DataGiftEnroll.deleteMany({});
    console.log("🗑️ Old DataGiftEnroll records cleared...");

    // Insert DataGiftEnroll seed
    const dataGiftSeeds = [
      {
        id: uuidv4(),
        senderId: "CUST100",
        receiverId: "CUST200",
        bundleName: "Gift 1GB",
        dataVolume: "1GB",
        validity: "7 Days",
        status: "initiated",
      },
      {
        id: uuidv4(),
        senderId: "CUST101",
        receiverId: "CUST201",
        bundleName: "Gift 5GB",
        dataVolume: "5GB",
        validity: "30 Days",
        status: "success",
      },
    ];

    const inserted = await DataGiftEnroll.insertMany(dataGiftSeeds);
    console.log("✅ DataGiftEnroll seeded:", inserted);

    process.exit(0);
  } catch (err) {
    console.error("❌ Seeding error:", err.message);
    process.exit(1);
  }
}

// Run seeder
connectDB().then(seedData);
