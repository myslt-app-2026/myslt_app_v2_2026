const mongoose = require("mongoose");
require("dotenv").config(); // to use MONGO_URI from .env
const EnhancedCurrentDailyUsage = require("./models/EnhancedCurrentDailyUsageModel");

const seedData = [
  {
    id: "USG1001",
    href: "/tmf-api/usageManagement/v4/usage/USG1001",
    usageDate: new Date("2025-09-20"),
    description: "Daily mobile data usage",
    usageType: "Data",
    status: "received",
    subscriberID: "SUB1001",
    billDate: "2025-09-20",
    usageCharacteristic: [
      { name: "volume", valueType: "MB", value: 500 },
      { name: "networkType", valueType: "string", value: "4G" }
    ],
    relatedParty: [
      {
        id: "CUST1001",
        name: "John Doe",
        role: "customer",
        "@referredType": "Individual"
      }
    ],
    usageSpecification: {
      id: "SPEC1001",
      name: "Daily Data Usage Spec",
      "@referredType": "UsageSpecification"
    }
  },
  {
    id: "USG1002",
    href: "/tmf-api/usageManagement/v4/usage/USG1002",
    usageDate: new Date("2025-09-21"),
    description: "Daily voice call usage",
    usageType: "Voice",
    status: "received",
    subscriberID: "SUB1002",
    billDate: "2025-09-21",
    usageCharacteristic: [
      { name: "minutes", valueType: "min", value: 45 },
      { name: "destination", valueType: "string", value: "Local" }
    ],
    relatedParty: [
      {
        id: "CUST1002",
        name: "Jane Smith",
        role: "customer",
        "@referredType": "Individual"
      }
    ],
    usageSpecification: {
      id: "SPEC1002",
      name: "Daily Voice Usage Spec",
      "@referredType": "UsageSpecification"
    }
  }
];

async function seed() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("✅ MongoDB connected");

    await EnhancedCurrentDailyUsage.deleteMany({});
    console.log("🗑️ Existing data cleared");

    await EnhancedCurrentDailyUsage.insertMany(seedData);
    console.log("🌱 Seed data inserted successfully");

    mongoose.connection.close();
  } catch (error) {
    console.error("❌ Error seeding database:", error);
    mongoose.connection.close();
  }
}

seed();
