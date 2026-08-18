const mongoose = require('mongoose');
require('dotenv').config();

// Path to connectDB remains correct: up 2 levels to src/config/db
const connectDB = require('../../config/db'); 
const BillCode = require('./models/BillCode.model'); 

// Connect to MongoDB
connectDB();

async function seedBillCodes() {
    try {
        console.log('--- Starting Database Seeding (TMF Bill Delivery Methods) ---');
        
        await BillCode.deleteMany({});
        console.log('Cleared existing BillDeliveryMethods documents.');

        const initialCodes = [
            // Map legacy codes to TMF names
            { id: "01", name: "Hard Copy", description: "Paper Bill", deliveryChannel: "HardCopy" },
            { id: "02", name: "E-statement by email", description: "E-statement by email", deliveryChannel: "Email" },
            { id: "03", name: "E-statement & Post", description: "E-statement & Post (Hybrid Delivery)", deliveryChannel: "HardCopy" },
            { id: "04", name: "E-statement on web", description: "E-statement delivered via customer portal/web", deliveryChannel: "App" },
            { id: "23", name: "E-Statement-App Mode", description: "E-Statement notification and viewing via application", deliveryChannel: "App" },
            { id: "24", name: "E-Statement by SMS", description: "E-Statement notification via SMS", deliveryChannel: "SMS" },
            { id: "25", name: "E-statement by WhatsApp", description: "E-statement notification via WhatsApp/SMS", deliveryChannel: "SMS" },
            { id: "26", name: "Corporate E-Bill", description: "Digital statement for corporate accounts", deliveryChannel: "Corporate" },
            { id: "12", name: "No Print", description: "Billing method with no printed output", deliveryChannel: "Other" }
        ];

        await BillCode.insertMany(initialCodes);
        console.log(`Successfully inserted ${initialCodes.length} TMF Bill Delivery Method documents.`);
        
    } catch (error) {
        console.error('--- Error seeding database: (Ensure MongoDB IP is whitelisted) ---', error.message);
        process.exit(1);
    } finally {
        await mongoose.connection.close();
        console.log('--- Database Seeding Complete and connection closed. ---');
    }
}

seedBillCodes();