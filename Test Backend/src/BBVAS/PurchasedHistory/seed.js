// src/BBVAS/PurchasedHistory/seed.js

const mongoose = require('mongoose');
const PurchasedHistory = require('./models/PurchasedHistory');
const connectDB = require('../../config/db');

require("dotenv").config(); 

const seedDatabase = async () => {
    try {
        await connectDB();
        console.log("✅ MongoDB connected for seeding.");

        await PurchasedHistory.deleteMany({});
        console.log("✅ Existing PurchasedHistory data removed.");

        const seedData = [
            {
                id: "usage-101",
                href: "http://localhost:3000/tmf-api/usage/v4/purchasedHistory/usage-101",
                description: "Usage for CTK GET test",
                usageDate: new Date('2025-09-08T00:00:00Z'),
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                relatedParty: [{ id: "customer-999", name: "Test User", role: "customer" }],
                usageItem: [{
                    id: "item-001",
                    itemPrice: { price: 50, unitOfMeasure: "LKR" },
                    product: { id: "prod-001", href: "http://example.com/prod/prod-001", name: "5GB Data Plan" },
                    usageCharacteristic: [{ name: "dataVolume", value: 500, unit: "MB" }]
                }]
            },
            {
                id: "usage-201",
                href: "http://localhost:3000/tmf-api/usage/v4/purchasedHistory/usage-201",
                description: "Usage for Sep 08",
                usageDate: new Date('2025-09-08T00:00:00Z'),
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                relatedParty: [{ id: "customer-123", name: "John Doe", role: "customer" }],
                usageItem: [{
                    id: "item-002",
                    itemPrice: { price: 25, unitOfMeasure: "LKR" },
                    product: { id: "prod-002", href: "http://example.com/prod/prod-002", name: "100 Min Pack" },
                    usageCharacteristic: [{ name: "callDuration", value: 100, unit: "min" }]
                }]
            },
            {
                id: "usage-202",
                href: "http://localhost:3000/tmf-api/usage/v4/purchasedHistory/usage-202",
                description: "Usage for Sep 09",
                usageDate: new Date('2025-09-09T00:00:00Z'),
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                relatedParty: [{ id: "customer-123", name: "John Doe", role: "customer" }],
                usageItem: [{
                    id: "item-003",
                    itemPrice: { price: 30, unitOfMeasure: "LKR" },
                    product: { id: "prod-003", href: "http://example.com/prod/prod-003", name: "Unlimited SMS" },
                    usageCharacteristic: [{ name: "smsCount", value: 50, unit: "sms" }]
                }]
            },
            {
                id: "usage-203",
                href: "http://localhost:3000/tmf-api/usage/v4/purchasedHistory/usage-203",
                description: "Usage for Sep 10",
                usageDate: new Date('2025-09-10T00:00:00Z'),
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                relatedParty: [{ id: "customer-123", name: "John Doe", role: "customer" }],
                usageItem: [{
                    id: "item-004",
                    itemPrice: { price: 45, unitOfMeasure: "LKR" },
                    product: { id: "prod-004", href: "http://example.com/prod/prod-004", name: "Social Media Pack" },
                    usageCharacteristic: [{ name: "dataVolume", value: 200, unit: "MB" }]
                }]
            },
            {
                id: "usage-204",
                href: "http://localhost:3000/tmf-api/usage/v4/purchasedHistory/usage-204",
                description: "Usage for Sep 10 for different user",
                usageDate: new Date('2025-09-10T00:00:00Z'),
                usageSpecification: { id: "spec-101", name: "Data Usage Spec" },
                relatedParty: [{ id: "customer-456", name: "Jane Smith", role: "customer" }],
                usageItem: [{
                    id: "item-005",
                    itemPrice: { price: 60, unitOfMeasure: "LKR" },
                    product: { id: "prod-005", href: "http://example.com/prod/prod-005", name: "Video Streaming" },
                    usageCharacteristic: [{ name: "dataVolume", value: 500, unit: "MB" }]
                }]
            }
        ];

        await PurchasedHistory.insertMany(seedData);
        console.log("✅ Seed data inserted successfully!");

    } catch (error) {
        console.error("❌ Seeding failed:", error.message);
    } finally {
        mongoose.connection.close();
        console.log("✅ MongoDB connection closed.");
    }
};

seedDatabase();