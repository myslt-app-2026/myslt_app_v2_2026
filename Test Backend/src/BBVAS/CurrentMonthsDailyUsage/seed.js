const mongoose = require('mongoose');
const DailyUsage = require('./models/dailyUsage');
const connectDB = require('../../config/db'); 

require("dotenv").config();

const seedDatabase = async () => {
    try {
        await connectDB();
        console.log("✅ MongoDB connected for seeding");

        await DailyUsage.deleteMany({});
        console.log("✅ Existing DailyUsage data removed.");

        const seedData = [
           
            {
                id: "usage-101",
                href: "http://localhost:3000/tmf-api/usageManagement/v4/usage/usage-101",
                description: "Usage for CTK GET test",
                isBilled: false,
                usageDate: new Date('2025-09-08T00:00:00Z'),
                usageType: "data",
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                usageCharacteristic: [{ name: "volume", value: 500, unit: "MB" }],
                relatedParty: [{ id: "customer-999", name: "Test User", role: "customer" }]
            },
          
            {
                id: "usage-201",
                href: "http://localhost:3000/tmf-api/usageManagement/v4/usage/usage-201",
                description: "Usage for Sep 08",
                isBilled: false,
                usageDate: new Date('2025-09-08T00:00:00Z'),
                usageType: "data",
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                usageCharacteristic: [{ name: "volume", value: 500, unit: "MB" }],
                relatedParty: [{ id: "customer-123", name: "John Doe", role: "customer" }]
            },
            {
                id: "usage-202",
                href: "http://localhost:3000/tmf-api/usageManagement/v4/usage/usage-202",
                description: "Usage for Sep 09",
                isBilled: false,
                usageDate: new Date('2025-09-09T00:00:00Z'),
                usageType: "data",
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                usageCharacteristic: [{ name: "volume", value: 650, unit: "MB" }],
                relatedParty: [{ id: "customer-123", name: "John Doe", role: "customer" }]
            },
            {
                id: "usage-203",
                href: "http://localhost:3000/tmf-api/usageManagement/v4/usage/usage-203",
                description: "Usage for Sep 10",
                isBilled: false,
                usageDate: new Date('2025-09-10T00:00:00Z'),
                usageType: "data",
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                usageCharacteristic: [{ name: "volume", value: 720, unit: "MB" }],
                relatedParty: [{ id: "customer-123", name: "John Doe", role: "customer" }]
            },
            {
                id: "usage-204",
                href: "http://localhost:3000/tmf-api/usageManagement/v4/usage/usage-204",
                description: "Usage for Sep 10 for different user",
                isBilled: false,
                usageDate: new Date('2025-09-10T00:00:00Z'),
                usageType: "data",
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                usageCharacteristic: [{ name: "volume", value: 300, unit: "MB" }],
                relatedParty: [{ id: "customer-456", name: "Jane Smith", role: "customer" }]
            }
        ];

        await DailyUsage.insertMany(seedData);
        console.log("✅ Seed data inserted successfully!");

    } catch (error) {
        console.error("❌ Seeding failed:", error.message);
    } finally {
        mongoose.connection.close();
        console.log("✅ MongoDB connection closed.");
    }
};

seedDatabase();
